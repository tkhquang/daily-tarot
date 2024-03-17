# Control all versions in one place
ARG ALPINE_VERSION=3.19.1
ARG ELIXIR_VERSION=1.16.2
ARG ERLANG_VERSION=26.2.3
ARG NODE_VERSION=20.11.1
ARG RUST_VERSION=1.76

# 1. Fetch Elixir deps
# - Elixir packages with package.json are brought together into deps-assets for asset compilation
FROM hexpm/elixir:$ELIXIR_VERSION-erlang-$ERLANG_VERSION-alpine-$ALPINE_VERSION as fetch-elixir-deps
RUN apk add --update --no-cache git build-base
RUN mkdir /app
WORKDIR /app
ENV MIX_ENV="dev"
RUN mix do local.hex --force, local.rebar --force
COPY mix.exs mix.lock ./
# Resolve eheap_alloc: Cannot allocate x bytes of memory (of type "heap_frag").
# error on Apply chip
RUN mix archive.install github hexpm/hex branch latest --force
RUN mix  archive.install hex phx_new
RUN if [ "${MIX_ENV}" = "dev" ]; then \
  mix deps.get; else mix deps.get --only "${MIX_ENV}"; fi
# For phoenix_live_reload to work
RUN if [ "${MIX_ENV}" = "dev" ]; then \
  apk add inotify-tools bash; fi
RUN mkdir deps-assets && find deps -name package.json -mindepth 2 -maxdepth 2 | while read i; do cp -R $(dirname $i) deps-assets; done

FROM alpine:$ALPINE_VERSION as extract-assets-from-lib
RUN mkdir -p /app/lib
WORKDIR /app
COPY lib/daily_tarot_web lib/daily_tarot_web
RUN find lib/daily_tarot_web -type f ! \( -name "*ex" \) -print | xargs rm -f
RUN find lib/daily_tarot_web -type d -empty | xargs -r rmdir -p --ignore-fail-on-non-empty

# 2a. Fetch Node modules -> compile Node assets
FROM node:$NODE_VERSION-alpine as build-node-assets
RUN mkdir /app
WORKDIR /app
RUN mkdir /app/assets
COPY assets/package.json assets/yarn.lock ./assets/
COPY --from=fetch-elixir-deps /app/deps-assets ./deps
RUN yarn --cwd assets install --immutable
COPY assets ./assets
RUN yarn --cwd assets deploy

# 2b. Fetch & compile Rust deps -> compile the Rust lib
# - the target-feature=-crt-static flag is needed for our lib to work on Alpine
# - Rustler's skip_compilation? flag is set to true in prod.exs to compile separately
# FROM rust:$RUST_VERSION-alpine as build-rust
# RUN apk add --update --no-cache git build-base protoc
# WORKDIR /
# RUN cargo new app --lib
# WORKDIR /app
# COPY native/daily_tarot_engine/Cargo.toml native/daily_tarot_engine/Cargo.lock ./
# ENV RUSTFLAGS="-C target-feature=-crt-static"
# RUN cargo rustc --release && rm -rf src
# COPY native/daily_tarot_engine/src src
# COPY native/daily_tarot_engine/build.rs .
# RUN cargo clean --package daily_tarot_engine --release && cargo rustc --release

# 2c. Compile Elixir deps -> compile Elixir app -> digest assets -> assemble the release
# - only the compile-time config is needed for compilation (runtime.exs follows later)
FROM fetch-elixir-deps as build
RUN mkdir config
# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile
COPY lib lib
COPY priv priv
RUN mkdir /app/assets
COPY assets assets
COPY --from=build-node-assets /app/assets assets
COPY priv/static/assets priv/static/assets
# Add glibc in order to use dart-sass
ENV GLIBC_VERSION=2.34-r0
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  wget -q -O /tmp/glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
  apk add --force-overwrite /tmp/glibc.apk && \
  rm -rf /tmp/glibc.apk
RUN apk add --no-cache gcompat
# Compile the release
RUN mix compile

# Compile assets
RUN mix assets.deploy
RUN mix phx.digest

#COPY rel rel

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/
# RUN mkdir -p priv/native
# COPY --from=build-rust /app/target/release/libdaily_tarot_engine.so priv/native/libdaily_tarot_engine.so
RUN mix release


# 3. Prepare non-root user -> copy the release
# - the SERVER env var is used in runtime.exs to enable Phoenix endpoint, Oban queues etc
FROM alpine:$ALPINE_VERSION AS app
RUN apk add --update --no-cache bash openssl postgresql-client libstdc++
RUN adduser -D -h /app app
WORKDIR /app
USER app
COPY --from=build --chown=app /app/_build/prod/rel/daily_tarot .
ENV HOME=/app
CMD bin/daily_tarot eval DailyTarot.Release.migrate && bin/daily_tarot start

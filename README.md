# DailyTarot

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Developmemt

Copy an example `.env` file because the real one is git ignored:

```sh
cp .env.example .env
```

Install assets packages

```sh
cd assets && yarn install
cd ..
```

The first time you run this it's going to take 5-10 minutes depending on your internet connection speed and computer's hardware specs. That's because it's going to download a few Docker images and build the Elixir + Yarn dependencies.

```sh
docker compose up -d
docker compose exec app sh
mix ecto.migrate
```

## Notes

`asdf` downloads source files and compiles Erlang on our machine. Install required dependencies for it. OpenSSL is required for secure communication and WxWidgets is needed for rendering out the debugger and observer. Even if you have OpenSSL installed, you need version `1.1`.

```sh
brew install openssl@1.1 wxwidgets
```

Since Erlang is compiled on our machine, it is recommended to set compile time flags to get an optimal binary. Erlang compile time flags are configured by setting the `KERL_CONFIGURE_OPTIONS` shell function. The below flags are used by [Jose Valim](https://twitter.com/josevalim/status/1507608988577316865?lang=en). These flags disable linking with Java, which is only required if you want to interface with Java.

```sh
export KERL_CONFIGURE_OPTIONS="--disable-debug --disable-silent-rules --without-javac --enable-shared-zlib --enable-dynamic-ssl-lib --enable-threads --enable-kernel-poll --enable-wx --enable-webview --enable-darwin-64bit --enable-gettimeofday-as-os-system-time --with-ssl=$(brew --prefix openssl@1.1)" KERL_BUILD_DOCS="yes"
```

```sh
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
asdf install
```

After installing `erlang` and `elixir` with `asdf`, we need to define the versions globally so that vscode would work properly

```sh
asdf global elixir 1.16.2-otp-26
asdf global erlang 26.2.3
```

Compiling Hex from scratch on the OTP version to bypass the memory bug on ElixirLS:

```sh
mix archive.install github hexpm/hex branch latest --force
mix archive.install hex phx_new
```

## TODO

* [ ] Optimistic UI
* [x] Add simple LQIP
* [x] Add dark theme and update default styles
* [ ] Dynamic translation
* [ ] Use prompts for updating contents
* [x] Self-aware date and time
* [x] Dockerization
* [x] Add TypeScript
* [ ] Add Svelte

## Learn more

* Official website: <https://www.phoenixframework.org/>
* Guides: <https://hexdocs.pm/phoenix/overview.html>
* Docs: <https://hexdocs.pm/phoenix>
* Forum: <https://elixirforum.com/c/phoenix-forum>
* Source: <https://github.com/phoenixframework/phoenix>

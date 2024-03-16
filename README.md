# DailyTarot

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Developmemt

Copy an example .env file because the real one is git ignored:

```bash
cp .env.example .env
```

The first time you run this it's going to take 5-10 minutes depending on your internet connection speed and computer's hardware specs. That's because it's going to download a few Docker images and build the Elixir + Yarn dependencies.

```bash
docker compose up -d
docker compose exec app sh
mix ecto.migrate
```

## Learn more

* Official website: <https://www.phoenixframework.org/>
* Guides: <https://hexdocs.pm/phoenix/overview.html>
* Docs: <https://hexdocs.pm/phoenix>
* Forum: <https://elixirforum.com/c/phoenix-forum>
* Source: <https://github.com/phoenixframework/phoenix>

## TODO

* [x] Add dark theme and update default styles
* [ ] Dynamic translation
* [ ] Use prompts for updating contents
* [x] Self-aware date and time
* [ ] Dockerization

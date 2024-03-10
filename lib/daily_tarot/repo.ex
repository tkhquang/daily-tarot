defmodule DailyTarot.Repo do
  use Ecto.Repo,
    otp_app: :daily_tarot,
    adapter: Ecto.Adapters.Postgres
end

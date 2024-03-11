defmodule DailyTarotUtils.WebHelper do
  @moduledoc false

  @doc """
  Conditional adding classes
  """
  def classes(classes) do
    classes
    |> Enum.filter(&elem(&1, 1))
    |> Enum.map(&elem(&1, 0))
    |> Enum.join(" ")
  end

  # Storage helpers
  def restore_from_token(token) do
    salt = Application.get_env(:daily_tarot, DailyTarotWeb.Endpoint)[:live_view][:signing_salt]
    # Max age is 1 day. 86,400 seconds
    case Phoenix.Token.decrypt(DailyTarotWeb.Endpoint, salt, token, max_age: 86_400) do
      {:ok, data} ->
        {:ok, data}

      {:error, reason} ->
        # handles `:invalid`, `:expired` and possibly other things?
        {:error, "Failed to restore previous state. Reason: #{inspect(reason)}."}
    end
  end

  def serialize_to_token(state_data) do
    salt = Application.get_env(:daily_tarot, DailyTarotWeb.Endpoint)[:live_view][:signing_salt]

    Phoenix.Token.encrypt(DailyTarotWeb.Endpoint, salt, %{
      data: state_data,
      timestamp: DateTime.utc_now()
    })
  end
end

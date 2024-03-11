defmodule DailyTarotUtils.Json do
  @moduledoc false

  @doc """
  Get and decode json file from file path
  """
  def get_json(file) do
    with {:ok, body} <- File.read(file),
         {:ok, json} <- Jason.decode(body) do
      {:ok, json}
    else
      _ -> {:error, "Failed to get and decode json file."}
    end
  end
end

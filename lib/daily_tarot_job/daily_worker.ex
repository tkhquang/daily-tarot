defmodule DailyTarotJob.DailyWorker do
  @moduledoc """
  Daily Workers
  """
  use Oban.Worker, queue: :default

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    IO.inspect("Daily worker is working")

    # WIP
    :ok
  end
end

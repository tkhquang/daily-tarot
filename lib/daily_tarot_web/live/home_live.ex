defmodule DailyTarotWeb.HomeLive do
  use DailyTarotWeb, :live_view

  def get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body), do: {:ok, json}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, cards} = get_json("assets/json/cards.json")
    socket = assign(socket, [cards: cards, random_cards: Enum.take_random(cards, 6) |> Enum.map(fn card -> Map.merge(card, %{"orientation" => [:upright, :reversed] |> Enum.random()}) end), flipped_card: nil, is_flipped: false])
    {:ok, socket}
  end

  @impl true
  def handle_event("flip_card", %{"card" => card} = _session , socket) do
    socket = assign(socket, [flipped_card: card, is_flipped: true])
    {:noreply, socket}
  end
end

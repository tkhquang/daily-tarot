defmodule DailyTarotWeb.HomeLive do
  use DailyTarotWeb, :live_view

  alias DailyTarot.Card
  alias DailyTarot.Helper

  @impl true
  def mount(_params, _session, socket) do
    {:ok, cards} = Helper.get_json("assets/json/cards.json")

    socket =
      assign(socket,
        cards: cards,
        random_cards: Card.get_random_cards(cards, 6),
        flipped_card: nil
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("flip_card", %{"card_number" => card_number} = _session, socket) do
    card = Card.get_card_by_number(socket.assigns.random_cards, card_number)

    socket =
      assign(socket,
        flipped_card: card,
        render_card_info: Card.get_render_info(card)
      )

    {:noreply, socket}
  end
end

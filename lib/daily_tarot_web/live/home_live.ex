defmodule DailyTarotWeb.HomeLive do
  use DailyTarotWeb, :live_view

  alias DailyTarot.Card
  alias DailyTarot.Helper

  require Logger

  @storage_key "DAILY_TAROT_STORAGE"

  @impl true
  def handle_params(_params, _, socket) do
    # Only try to talk to the client when the websocket
    # is setup. Not on the initial "static" render.
    new_socket =
      if connected?(socket) do
        # This represents some meaningful key to your LiveView that you can
        # store and restore state using. Perhaps an ID from the page
        # the user is visiting?
        # For handle_params, it could be
        # storage_key = params["id"]

        socket
        |> assign(:storage_key, @storage_key)
        # request the browser to restore any state it has for this key.
        |> push_event("restore", %{key: @storage_key, event: "restore_settings"})
      else
        socket
      end

    {:noreply, new_socket}
  end

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

  defp restore_from_token(token) do
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

  defp serialize_to_token(state_data) do
    salt = Application.get_env(:daily_tarot, DailyTarotWeb.Endpoint)[:live_view][:signing_salt]
    Phoenix.Token.encrypt(DailyTarotWeb.Endpoint, salt, state_data)
  end

  # Push a websocket event down to the browser's JS hook.
  # Clear any settings for the current storage_key.
  defp clear_browser_storage(socket) do
    push_event(socket, "clear", %{key: socket.assigns.storage_key})
  end

  @impl true
  # Pushed from JS hook. Server requests it to send up any
  # stored settings for the key.
  def handle_event("restore_settings", token_data, socket) when is_binary(token_data) do
    socket =
      case restore_from_token(token_data) do
        {:ok, nil} ->
          # do nothing with the previous state
          socket

        {:ok,
         %{
           random_cards: random_cards,
           flipped_card: flipped_card
         }} ->
          socket
          |> assign(:random_cards, random_cards)
          |> assign(:flipped_card, flipped_card)
          |> assign(:render_card_info, Card.get_render_info(flipped_card))

        {:error, reason} ->
          # We don't continue checking. Display error.
          # Clear the token so it doesn't keep showing an error.
          socket
          |> put_flash(:error, reason)
          |> clear_browser_storage()
      end

    {:noreply, socket}
  end

  def handle_event("restore_settings", _token_data, socket) do
    # No expected token data received from the client
    Logger.debug("No LiveView SessionStorage state to restore")
    {:noreply, socket}
  end

  @impl true
  def handle_event("flip_card", %{"card_number" => card_number} = _session, socket) do
    card = Card.get_card_by_number(socket.assigns.random_cards, card_number)

    socket =
      socket
      |> assign(
        flipped_card: card,
        render_card_info: Card.get_render_info(card)
      )
      |> push_event("store", %{
        key: socket.assigns.storage_key,
        data:
          serialize_to_token(%{
            random_cards: socket.assigns.random_cards,
            flipped_card: card
          })
      })

    {:noreply, socket}
  end

  @impl true
  def handle_event("pick_another_card", _session, socket) do
    socket =
      socket
      |> assign(
        flipped_card: nil,
        render_card_info: nil
      )
      |> push_event("store", %{
        key: socket.assigns.storage_key,
        data:
          serialize_to_token(%{
            random_cards: socket.assigns.random_cards,
            flipped_card: nil
          })
      })

    {:noreply, socket}
  end

  @impl true
  def handle_event("shuffle_the_cards", _session, socket) do
    new_random_cards = Card.get_random_cards(socket.assigns.cards, 6)

    socket =
      socket
      |> assign(
        random_cards: new_random_cards,
        flipped_card: nil,
        render_card_info: nil
      )
      |> push_event("store", %{
        key: socket.assigns.storage_key,
        data:
          serialize_to_token(%{
            random_cards: new_random_cards,
            flipped_card: nil
          })
      })

    {:noreply, socket}
  end
end

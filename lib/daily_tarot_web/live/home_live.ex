defmodule DailyTarotWeb.HomeLive do
  use DailyTarotWeb, :live_view

  import DailyTarotWeb.Interpretation
  import DailyTarotWeb.TarotCard.FlipCard

  alias DailyTarot.Card
  alias DailyTarotUtils.Json

  require Logger

  @storage_key "DAILY_TAROT_STORAGE"

  @impl true
  def mount(_params, _session, socket) do
    socket =
      case Json.get_json("assets/json/cards.json") do
        {:ok, cards} ->
          socket =
            assign(socket,
              cards: cards,
              random_cards: Card.get_random_cards(cards, 6),
              flipped_card: nil,
              is_loading: true,
              locale: nil,
              timezone: nil,
              timezone_offset: nil,
              color_mode: nil
            )

          socket

        _ ->
          socket =
            assign(socket,
              cards: [],
              random_cards: Card.get_random_cards([], 6),
              flipped_card: nil,
              is_loading: true,
              locale: nil,
              timezone: nil,
              timezone_offset: nil,
              color_mode: nil
            )

          socket
      end

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    # Only try to talk to the client when the websocket
    # is setup. Not on the initial "static" render.

    # TODO: Break down to multiple branches later
    new_socket =
      if connected?(socket) do
        %{
          "locale" => locale,
          "timezone" => timezone,
          "timezone_offset" => timezone_offset,
          "color_mode" => color_mode
        } = get_connect_params(socket)

        socket
        |> assign(
          locale: locale,
          timezone: timezone,
          timezone_offset: timezone_offset,
          color_mode: color_mode
        )
      else
        socket
      end

    new_socket =
      if connected?(new_socket) do
        # This represents some meaningful key to your LiveView that you can
        # store and restore state using. Perhaps an ID from the page
        # the user is visiting?
        # For handle_params, it could be
        # storage_key = params["id"]

        new_socket
        |> assign(:storage_key, @storage_key)
        # request the browser to restore any state it has for this key.
        |> push_event("localStorage.restore", %{key: @storage_key, event: "restore_settings"})
      else
        socket
      end

    {:noreply, new_socket}
  end

  @impl true
  # Pushed from JS hook. Server requests it to send up any
  # stored settings for the key.
  def handle_event("restore_settings", token_data, socket) when is_binary(token_data) do
    %{
      assigns: %{
        timezone: timezone
      }
    } = socket

    socket =
      case restore_from_token(token_data) do
        {:ok, nil} ->
          # do nothing with the previous state
          socket

        {:ok,
         %{
           data: %{
             random_cards: random_cards,
             flipped_card: flipped_card
           },
           timestamp: timestamp
         }} ->
          {:ok, timestamp} = timestamp |> DateTime.shift_zone(timezone)
          {:ok, now} = DateTime.utc_now() |> DateTime.shift_zone(timezone)

          case Date.compare(now, timestamp) do
            :gt ->
              socket
              |> assign(:random_cards, Card.get_random_cards(socket.assigns.cards, 6))
              |> assign(:flipped_card, nil)
              |> assign(:render_card_info, nil)

            _ ->
              socket
              |> assign(:random_cards, random_cards)
              |> assign(:flipped_card, flipped_card)
              |> assign(:render_card_info, Card.get_render_info(flipped_card))
          end

        {:error, reason} ->
          # We don't continue checking. Display error.
          # Clear the token so it doesn't keep showing an error.
          socket
          |> put_flash(:error, reason)
          |> push_event("localStorage.clear", %{key: socket.assigns.storage_key})
      end

    socket =
      if connected?(socket) do
        socket
        |> assign(is_loading: false)
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_event("restore_settings", _token_data, socket) do
    # No expected token data received from the client
    Logger.debug("No LiveView SessionStorage state to restore")

    socket =
      if connected?(socket) do
        socket
        |> assign(is_loading: false)
      else
        socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "flip_card",
        %{
          "card_number" => card_number,
          "index" => _index
        } = _session,
        socket
      ) do
    card = Card.get_card_by_number(socket.assigns.random_cards, card_number)
    flipped_card_number = (socket.assigns.flipped_card || %{}) |> Map.get("number")

    socket =
      case "#{card_number}" == "#{flipped_card_number}" do
        true ->
          socket =
            socket
            |> assign(
              flipped_card: nil,
              render_card_info: nil
            )
            |> push_event("localStorage.store", %{
              key: socket.assigns.storage_key,
              data:
                serialize_to_token(%{
                  random_cards: socket.assigns.random_cards,
                  flipped_card: nil
                })
            })

          socket

        false ->
          socket =
            socket
            |> assign(
              flipped_card: card,
              render_card_info: Card.get_render_info(card)
            )
            |> push_event("localStorage.store", %{
              key: socket.assigns.storage_key,
              data:
                serialize_to_token(%{
                  random_cards: socket.assigns.random_cards,
                  flipped_card: card
                })
            })

          socket
      end

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
      |> push_event("localStorage.store", %{
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

    Process.sleep(1000)

    socket =
      socket
      |> assign(
        random_cards: new_random_cards,
        flipped_card: nil,
        render_card_info: nil
      )
      |> push_event("localStorage.store", %{
        key: socket.assigns.storage_key,
        data:
          serialize_to_token(%{
            random_cards: new_random_cards,
            flipped_card: nil
          })
      })

    {:noreply, socket}
  end

  @impl true
  def handle_event("imageLoadingState.loaded", %{"id" => _id} = _session, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("imageLoadingState.error", %{"id" => _id} = _session, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_theme", _session, socket) do
    socket =
      socket
      |> push_event("darkThemeToggle", %{})

    {:noreply, socket}
  end

  @impl true
  def handle_event("darkThemeToggle.changed", %{"mode" => mode} = _session, socket) do
    {:noreply, socket |> assign(:color_mode, mode)}
  end

  @impl true
  def handle_event("web_console", session, socket) do
    {:noreply, socket |> push_event("console.log", session)}
  end
end

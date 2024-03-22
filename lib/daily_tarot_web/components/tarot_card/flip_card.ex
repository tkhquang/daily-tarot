defmodule DailyTarotWeb.TarotCard.FlipCard do
  @moduledoc false
  use DailyTarotWeb, :html

  alias DailyTarotWeb.TarotCard.FlipCardImage

  @spec on_mount(any(), any()) :: any()
  def on_mount(js \\ %JS{}, is_flipped_card) do
    if is_flipped_card,
      do:
        js
        |> JS.add_class("rotate-y-180")
        |> JS.set_attribute({"data-selected", "true"}),
      else: js
  end

  def on_click(js \\ %JS{}, id) do
    js
    |> JS.toggle_class("rotate-y-180")
    |> JS.remove_class("rotate-y-180", to: ".card[data-selected='true']")
    |> JS.set_attribute({"data-selected", "false"}, to: ".card[data-selected='true']")
    |> JS.set_attribute({"data-selected", "true"}, to: "##{id}")
    |> JS.push("flip_card")
  end

  def flip_card(assigns) do
    flipped_card_number = (assigns.flipped_card || %{}) |> Map.get("number")
    card_number = assigns.card |> Map.get("number")
    orientation = assigns.card |> Map.get("orientation")

    assigns =
      assign(
        assigns,
        is_flipped_card: "#{flipped_card_number}" == "#{card_number}",
        card_number: card_number,
        orientation: orientation,
        id: "card-#{card_number}"
      )

    ~H"""
    <div class="group perspective w-full cursor-pointer bg-transparent">
      <div
        id={@id}
        class={[
          "card pb-[calc(100%*1834/1114)] preserve-3d relative h-full w-full duration-1000",
          classes(
            "[&[data-selected='true']]:shadow-[0_0_120px_-15px_theme(colors.theme.primary)]": false
          )
        ]}
        data-index={@index}
        phx-mounted={on_mount(@is_flipped_card)}
        phx-click={on_click(@id)}
        phx-value-card_number={@card_number}
        phx-value-index={@index}
      >
        <div class="backface-hidden absolute h-full w-full overflow-hidden rounded shadow-md md:rounded-lg">
          <.live_component
            module={FlipCardImage}
            card_number={:preview}
            orientation={@orientation}
            id={"back-#{@index}"}
          />
        </div>
        
        <div class="rotate-y-180 backface-hidden surface absolute h-full w-full overflow-hidden rounded shadow-md md:rounded-lg">
          <.live_component
            module={FlipCardImage}
            card_number={@card_number}
            orientation={@orientation}
            id={"front-#{@index}"}
          />
        </div>
      </div>
    </div>
    """
  end
end

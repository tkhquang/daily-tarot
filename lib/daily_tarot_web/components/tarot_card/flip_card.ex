defmodule DailyTarotWeb.TarotCard.FlipCard do
  @moduledoc false
  use DailyTarotWeb, :html

  alias DailyTarotWeb.TarotCard.FlipCardImage

  def flip_card(assigns) do
    flipped_card_number = (assigns.flipped_card || %{}) |> Map.get("number")
    card_number = assigns.card |> Map.get("number")
    orientation = assigns.card |> Map.get("orientation")

    assigns =
      assign(
        assigns,
        is_flipped_card: flipped_card_number == card_number,
        card_number: card_number,
        orientation: orientation
      )

    ~H"""
    <div class={[
      "group perspective w-full bg-transparent",
      if(@is_flipped, do: "cursor-not-allowed", else: "cursor-pointer")
    ]}>
      <div
        class={[
          "pb-[calc(100%*1834/1114)] preserve-3d relative h-full w-full duration-1000",
          classes("rotate-y-180": @is_flipped_card)
        ]}
        data-index={@index}
        phx-click={if !@is_flipped, do: "flip_card", else: nil}
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
        
        <div class="rotate-y-180 backface-hidden absolute h-full w-full overflow-hidden rounded shadow-md md:rounded-lg">
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

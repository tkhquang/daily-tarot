defmodule DailyTarotWeb.TarotCard.FlipCard do
  @moduledoc false
  use Phoenix.Component

  import DailyTarotUtils.WebHelper, only: [classes: 1]
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
      "aspect-[1114/1834] bg-transparent group perspective",
      if(@is_flipped, do: "cursor-not-allowed", else: "cursor-pointer")
    ]}>
      <div
        class={[
          "relative preserve-3d w-full h-full duration-1000 shadow-md",
          classes("rotate-y-180": @is_flipped_card)
        ]}
        data-index={@index}
        phx-click={if !@is_flipped, do: "flip_card", else: nil}
        phx-value-card_number={@card_number}
        phx-value-index={@index}
      >
        <.live_component
          module={FlipCardImage}
          card_number={:preview}
          id={"back-#{@index}"}
          orientation={@orientation}
        />
        <div class="absolute rotate-y-180 backface-hidden w-full h-full bg-gray-100 overflow-hidden">
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

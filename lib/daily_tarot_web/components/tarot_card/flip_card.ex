defmodule DailyTarotWeb.TarotCard.FlipCard do
  @moduledoc false
  use Phoenix.Component

  alias DailyTarot.Card
  import DailyTarotUtils.WebHelper

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
        <div class="absolute backface-hidden border-2 w-full h-full">
          <img class="w-full h-full text-white" src={Card.get_image_url(:preview)} alt="Flipped card" />
        </div>
        
        <div class="absolute rotate-y-180 backface-hidden w-full h-full bg-gray-100 overflow-hidden">
          <img
            class={[
              "w-full h-full",
              classes("rotate-180": @orientation == :reversed)
            ]}
            src={Card.get_image_url(@card)}
            alt={Card.get_name(@card)}
          />
        </div>
      </div>
    </div>
    """
  end
end

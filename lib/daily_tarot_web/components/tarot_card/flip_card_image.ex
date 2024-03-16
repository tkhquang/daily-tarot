defmodule DailyTarotWeb.TarotCard.FlipCardImage do
  @moduledoc false
  use Phoenix.LiveComponent

  alias DailyTarot.Card
  import DailyTarotUtils.WebHelper, only: [classes: 1]

  def render(assigns) do
    ~H"""
    <div class="overflow-hidden">
      <img
        id={@id}
        class={[
          "lqip-image [&[data-js-loading='false']]:lqip-image__loaded [&[data-js-loading='false']~img]:lqip-placeholder__image-loaded [&[data-js-loading='true']]:text-[0px]",
          classes("rotate-180": @orientation == :reversed)
        ]}
        src={Card.get_image_url(@card_number)}
        alt="Flipped card"
        phx-hook="ImageLoadingState"
      />
      <img
        id={"placeholder-" <> @id}
        class={[
          "lqip-placeholder pointer-events-none absolute inset-0 transform-gpu [&[data-js-loading='true']]:text-[0px]",
          classes("rotate-180": @orientation == :reversed)
        ]}
        src={Card.get_image_url(@card_number, :placeholder)}
        alt="Flipped card"
        phx-hook="ImageLoadingState"
      />
    </div>
    """
  end
end

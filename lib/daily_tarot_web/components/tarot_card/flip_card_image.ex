defmodule DailyTarotWeb.TarotCard.FlipCardImage do
  @moduledoc false
  use Phoenix.Component

  alias DailyTarot.Card

  def flip_card_image(assigns) do
    assigns =
      assign(
        assigns,
        is_loaded: false,
        id: UUID.uuid4()
      )

    ~H"""
    <div class="absolute backface-hidden border-2 w-full h-full overflow-hidden">
      <img
        id={@id}
        class="[&[data-loading='false']~img]:lqip-placeholder__image-loaded lqip-image [&[data-loading='false']]:lqip-image__loaded [&[data-loading='true']]:text-[0px]"
        src={Card.get_image_url(@card_number)}
        alt="Flipped card"
        phx-hook="ImageLoadingState"
      />
      <img
        id={"placeholder" <> @id}
        class="lqip-placeholder absolute inset-0 pointer-events-none transform-gpu [&[data-loading='true']]:text-[0px]"
        src={Card.get_image_url(@card_number, :placeholder)}
        alt="Flipped card"
        phx-hook="ImageLoadingState"
      />
    </div>
    """
  end
end

defmodule DailyTarotWeb.TarotCard.FlipCardImage do
  @moduledoc false
  use DailyTarotWeb, :live_component

  alias DailyTarot.Card

  def render(assigns) do
    ~H"""
    <div class="overflow-hidden">
      <div
        id={"skeleton-" <> @id}
        role="status"
        class="absolute inset-0 animate-pulse space-y-8 [&:has(~img:not([data-js-loading='true']))]:hidden [&[data-js-image-loading='false']]:hidden rtl:space-x-reverse md:flex md:items-center md:space-x-8 md:space-y-0"
      >
        <div class="surface flex h-full w-full items-center justify-center rounded">
          <svg
            class="surface h-10 w-10 opacity-30"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="currentColor"
            viewBox="0 0 20 18"
          >
            <path d="M18 0H2a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2Zm-5.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3Zm4.376 10.481A1 1 0 0 1 16 15H4a1 1 0 0 1-.895-1.447l3.5-7A1 1 0 0 1 7.468 6a.965.965 0 0 1 .9.5l2.775 4.757 1.546-1.887a1 1 0 0 1 1.618.1l2.541 4a1 1 0 0 1 .028 1.011Z" />
          </svg>
        </div>
        <span class="sr-only">Loading...</span>
      </div>
      <img
        id={@id}
        class={[
          "lqip-image [&:not([data-js-loading='false'])]:text-[0px] [&[data-js-loading='false']]:lqip-image__loaded [&[data-js-loading='false']]:text-white [&[data-js-loading='false']~img]:lqip-placeholder__image-loaded",
          classes("rotate-180": @orientation == :reversed)
        ]}
        src={Card.get_image_url(@card_number)}
        alt="Flipped card"
        phx-hook="ImageLoadingState"
      />
      <img
        id={"placeholder-" <> @id}
        class={[
          "lqip-placeholder pointer-events-none absolute inset-0 transform-gpu [&:not([data-js-loading='false'])]:text-[0px]",
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

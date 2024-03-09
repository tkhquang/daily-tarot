defmodule DailyTarotWeb.Components do
  use Phoenix.LiveComponent

  alias Phoenix.LiveView.JS
  alias DailyTarot.Helper

  defp flip_card(card, index, false) do
    IO.inspect(card)
    JS.add_class("rotate-y-180", to: ".card[data-index=\"#{index}\"]")
    |> JS.push("flip_card", value: %{card: card, index: index})
  end

  defp flip_card(_card, _index, true), do: nil

  def card(assigns) do
    ~H"""
    <div
      class={["aspect-[1114/1834] bg-transparent group perspective", Helper.classes("cursor-not-allowed": @is_flipped, "cursor-pointer": !@is_flipped)]}
    >
      <div
        class="card relative preserve-3d w-full h-full duration-1000 shadow-md"
        data-index={@index}
        phx-click={flip_card(@card, @index, @is_flipped)}
      >
        <div class="absolute backface-hidden border-2 w-full h-full">
          <img class="w-full h-full" src={DailyTarot.Card.get_image_url(:preview)} alt="closed" />
        </div>
        <div
          class="absolute rotate-y-180 backface-hidden w-full h-full bg-gray-100 overflow-hidden"
        >
          <img class={["w-full h-full", Helper.classes("rotate-180": @card |> Map.get("orientation") == :reversed)]} src={DailyTarot.Card.get_image_url(@card)} alt={@card |> Map.get("name")} />
        </div>
      </div>
    </div>
    """
  end
end

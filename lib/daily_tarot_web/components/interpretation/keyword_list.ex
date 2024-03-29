defmodule DailyTarotWeb.Interpretation.KeywordList do
  @moduledoc false
  use Phoenix.Component

  attr :render_card_info, :map, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def keyword_list(assigns) do
    ~H"""
    <ul class={["flex flex-wrap justify-center", @class]} {@rest}>
      <%= for {keyword, _index} <- @render_card_info.keywords |> Enum.with_index() do %>
        <li class="secondary m-2 rounded px-2.5 py-2">
          <span class="font-medium capitalize">
            <%= keyword %>
          </span>
        </li>
      <% end %>
    </ul>
    """
  end
end

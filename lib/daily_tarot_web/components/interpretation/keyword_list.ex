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
        <li class="my-2">
          <span class="text-blue-800 font-medium me-2 px-2.5 py-2 rounded dark:bg-blue-900 dark:text-blue-300 bg-blue-100">
            <%= keyword %>
          </span>
        </li>
      <% end %>
    </ul>
    """
  end
end

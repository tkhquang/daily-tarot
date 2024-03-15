defmodule DailyTarotWeb.Interpretation.AffirmationList do
  @moduledoc false
  use Phoenix.Component

  attr :render_card_info, :map, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def affirmation_list(assigns) do
    ~H"""
    <div class={[@class]} {@rest}>
      <h2 class="font-bold">Affirmations</h2>
      
      <ul class="mx-4 md:mx-8 list-disc">
        <%= for {affirmation, _index} <- @render_card_info.affirmations |> Enum.with_index() do %>
          <li class="">
            <p><%= affirmation %></p>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end

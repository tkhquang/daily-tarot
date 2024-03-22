defmodule DailyTarotWeb.Interpretation.Description do
  @moduledoc false
  use Phoenix.Component

  attr :render_card_info, :map, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def description(assigns) do
    ~H"""
    <div class={[@class]} {@rest}>
      <p :if={@render_card_info.description != nil}>
        <%= @render_card_info.description %>
      </p>

      <p :if={@render_card_info.general != nil}>
        <%= @render_card_info.general %>
      </p>

      <div :if={@render_card_info.career != nil} class="my-4">
        <h2 class="font-bold">Career 🎯</h2>

        <p>
          <%= @render_card_info.career %>
        </p>
      </div>

      <div :if={@render_card_info.love != nil} class="my-4">
        <h2 class="font-bold">Love 💕</h2>

        <p>
          <%= @render_card_info.love %>
        </p>
      </div>

      <div :if={@render_card_info.spirituality != nil} class="my-4">
        <h2 class="font-bold">Spirituality 🌿</h2>

        <p>
          <%= @render_card_info.spirituality %>
        </p>
      </div>
    </div>
    """
  end
end

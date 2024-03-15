defmodule DailyTarotWeb.Interpretation.Header do
  @moduledoc false
  use Phoenix.Component

  attr :render_card_info, :map, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def header(assigns) do
    ~H"""
    <div
      class={[
        "text-center",
        @class
      ]}
      {@rest}
    >
      <h1>
        <%= @render_card_info.name %>
      </h1>
    </div>
    """
  end
end

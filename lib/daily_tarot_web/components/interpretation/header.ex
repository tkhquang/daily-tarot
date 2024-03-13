defmodule DailyTarotWeb.Interpretation.Header do
  @moduledoc false
  use Phoenix.Component

  attr :render_card_info, :map, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def header(assigns) do
    ~H"""
    <h1
      class={[
        "text-4xl font-extrabold leading-none tracking-tight md:text-5xl lg:text-6xl text-center",
        @class
      ]}
      {@rest}
    >
      <%= @render_card_info.name %>
    </h1>
    """
  end
end

defmodule DailyTarotWeb.Interpretation do
  @moduledoc false
  use Phoenix.Component

  import DailyTarotWeb.Interpretation.{
    AffirmationList,
    Description,
    Header,
    KeywordList
  }

  attr :render_card_info, :map, required: true
  attr :rest, :global

  def interpretation(assigns) do
    ~H"""
    <div {@rest}>
      <.header render_card_info={@render_card_info} class="!mt-14 typography" />
      <.keyword_list render_card_info={@render_card_info} class="my-4" />
      <.description render_card_info={@render_card_info} class="my-4 typography" />
      <.affirmation_list render_card_info={@render_card_info} class="my-4 typography" />
    </div>
    """
  end
end

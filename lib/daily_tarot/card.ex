defmodule DailyTarot.Card do
  @orientations ~w(upright reversed)a

  defp imgix_url() do
    Application.fetch_env!(:daily_tarot, DailyTarot)[:imgix_url]
  end

  def get_card_by_number(cards, number) do
    card =
      cards
      |> Enum.find(fn card -> card |> Map.get("number") |> Integer.to_string() == number end)

    card
  end

  def get_random_cards(cards, number_of_cards) do
    Enum.take_random(cards, number_of_cards)
    |> Enum.map(fn card ->
      Map.merge(card, %{
        "orientation" => @orientations |> Enum.random()
      })
    end)
  end

  def get_image_url(:preview),
    do: "#{imgix_url()}/cards/78.webp?&q=80&dpr=0.5&auto=format"

  def get_image_url(number) do
    "#{imgix_url()}/cards/#{number}.webp?&q=80&dpr=0.5&auto=format"
  end

  def get_image_url(:preview, :placeholder),
    do: "#{imgix_url()}/cards/78.webp?blur=200&px=16&q=75&dpr=0.5&auto=format"

  def get_image_url(number, :placeholder) do
    "#{imgix_url()}/cards/#{number}.webp?blur=200&px=16&q=75&dpr=0.5&auto=format"
  end

  def get_name(%{
        "name" => name,
        "orientation" => orientation
      })
      when orientation == :upright do
    "#{name}"
  end

  def get_name(card) do
    %{
      "name" => name
    } = card

    "Reversed #{name}"
  end

  def get_render_info(nil), do: nil

  def get_render_info(card) do
    %{
      "orientation" => orientation,
      "keywords" => keywords,
      "affirmations" => affirmations,
      "description" => description
    } = card

    orientation = orientation |> Atom.to_string()

    case description |> Map.get(orientation) do
      %{
        "general" => general,
        "career" => career,
        "love" => love,
        "spirituality" => spirituality
      } ->
        %{
          name: get_name(card),
          orientation: orientation,
          keywords: keywords |> Map.get(orientation),
          affirmations: affirmations |> Map.get(orientation),
          description: nil,
          general: general,
          career: career,
          love: love,
          spirituality: spirituality
        }

      _ ->
        %{
          name: get_name(card),
          orientation: orientation,
          keywords: keywords |> Map.get(orientation),
          affirmations: affirmations |> Map.get(orientation),
          description: description |> Map.get(orientation),
          general: nil,
          career: nil,
          love: nil,
          spirituality: nil
        }
    end
  end
end

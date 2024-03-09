defmodule DailyTarot.Card do
  def get_image_url(:preview), do: "/images/cards/78.webp"

  def get_image_url(card) do
    %{
      "number" => number,
    } = card

    "/images/cards/#{number}.webp"
  end

  def get_name(%{
    "name" => name,
    "number" => number,
    "orientation" => orientation
  }) when orientation == "upright" do
    "#{name}"
  end

  def get_name(card) do
    %{
      "name" => name,
    } = card

    "Reversed #{name}"
  end
end

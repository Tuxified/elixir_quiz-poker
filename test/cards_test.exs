defmodule CardsTest do
  use ExUnit.Case

  test "new deck with enough cars" do
    assert Enum.count(Cards.new_deck) == 52
  end
  
  test "new deck seems random" do
    colours = Enum.take(Cards.new_deck, 10) |> Enum.uniq(fn [x, _] -> x end)
    assert Enum.count(colours) > 1
  end
end

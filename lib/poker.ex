defmodule Poker do

  @doc """
  Given a deck of cards, deal cards into different hands. Deal rhytm (first 3, then 2 cards)
  not implemented yet
  """

  @spec deal_cards(List, Integer, List) :: List
  def deal_cards(deck, amount_players \\ 2, _deal_rhytm \\ [1]) do
    deck
    |> Stream.take(5 * amount_players)
    |> Stream.with_index
    |> Enum.group_by(fn({card, index}) -> rem(index, amount_players) end)
    |> Enum.into [], fn({num, cards}) -> Enum.map(cards, fn({card, _num}) -> card end) end
  end

  def compare_hands(list_of_hands) do
    list_of_hands
    |> Enum.map(&sort_hand/1)
    |> Enum.map(&determine_score/1)
  end

  def sort_hand(hand) do
    Enum.sort_by(hand, fn([_colour, number]) -> card_value(number) end)
  end

  defp card_value(number), do: Enum.find_index(Cards.numbers, &(&1 == number))

  # TODO: implement straight flush
  def determine_score([[a, 2], [a, 3], [a, 4], [a, 5], [a, 14]]), do: 900 # flush starting with ace
  def determine_score([[a, first], [a, _b], [a, _c], [a, _d], [a, fifth]]) do
    # straght or no straight, that's the question
    straight = card_value(fifth) - card_value(first) == 4
    case straight do
      true -> 900 + card_value(fifth)
      false -> 600 + card_value(fifth)
    end
  end

  # Four of a kind
  def determine_score([[_, a], [_, a], [_, a], [_, a], _]), do: 800 + card_value(a)
  def determine_score([_, [_, a], [_, a], [_, a], [_, a]]), do: 800 + card_value(a)

  # Full house
  def determine_score([[_, a], [_, a], [_, b], [_, b], [_, b]]), do: 700 + (card_value(a) * 2) + (card_value(b) * 3)
  def determine_score([[_, b], [_, b], [_, b], [_, a], [_, a]]), do: 700 + (card_value(a) * 3) + (card_value(b) * 2)

  # Flush: five cards of same colour, non-consecutive numbers
  # def determine_score([[a, a1], [a, _a2], [a, _a3], [a, _a4], [a, _a5]]), do: 700 + card_value(a1)

  # TODO: implement straight

  # Three of a kind
  def determine_score([_, _, [_, a], [_, a], [_, a]]), do: 400 + card_value(a)
  def determine_score([[_, a], [_, a], [_, a], _, _]), do: 400 + card_value(a)

  # Two pairs
  def determine_score([_, [_, a], [_, a], [_, b], [_, b]]), do: 300 + card_value(a)
  def determine_score([[_, a], [_, a], [_, a], _, _]), do: 300 + card_value(a)

  # One pair
  def determine_score([[_, a], [_, a], _ , _, _]), do: 200 + card_value(a)
  def determine_score([_, [_, a], [_, a], _, _]), do: 200 + card_value(a)
  def determine_score([_, _, [_, a], [_, a], _]), do: 200 + card_value(a)
  def determine_score([_, _, _, [_, a], [_, a]]), do: 200 + card_value(a)

  # Something
  def determine_score(hand) do
    numbers = hand
      |> Stream.map(fn [_, number] -> number end)
      |> Enum.map(fn number -> card_value(number) end)

    straight = numbers == Enum.to_list(List.first(numbers) .. List.last(numbers))

    case straight do
      true -> 500 + card_value(List.last(numbers))
      false -> numbers |> Enum.sum
    end
  end
end

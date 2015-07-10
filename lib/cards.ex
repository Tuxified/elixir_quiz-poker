defmodule Cards do
  @colours [:hearts, :clubs, :diamonds, :spades]
  @numbers Enum.to_list(2..10) ++ [:jack, :queen, :king, :ace]
  
  def new_deck() do
    :random.seed(:os.timestamp) # set seed for randomazation
    for colour <- @colours, number <- @numbers do
      [ colour, number ]
    end
    |> Enum.shuffle
  end

  def numbers, do: @numbers
end

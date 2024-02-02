# frozen_string_literal: true

# Player class stores and manages player information
class Player
  attr_accessor :positions, :score, :name, :symbol

  def initialize(name, symbol = Symbol.choose_sym, positions = [], score = 0 )
    @name = name
    @symbol = symbol
    @positions = positions
    @score = score
  end
end

# creates a symbol (icon) for the player
class Symbol
  def choose_sym
    # create an array of symbols and use rand to choose one of the array items
    symbols = %w[@ $ # & = + A X O M]
    choice = symbols[rand(0..symbols.length-1)]
    return choice
  end
end
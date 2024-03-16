# frozen_string_literal: true

require 'curses'

# The Termship::Board class represents the game board for the Termship game.
class Termship::Board
  attr_reader :grid, :ships, :hits

  # Initializes a new instance of the Termship::Board class.
  def initialize
    @rows = 10
    @columns = 10
    @grid = Array.new(@rows) { Array.new(@columns, :water) }
    @ships = []
    @hits = []
  end

  # Places a ship on the board at the specified position and orientation.
  #
  # @param ship [Ship] The ship to be placed on the board.
  # @param initial_position [Position] The initial position where the ship will be placed.
  # @param orientation [Symbol] The orientation of the ship (:horizontal or :vertical).
  def place_ship(ship, initial_position, orientation)
    @ships << ship
    row = initial_position.row
    column = initial_position.column

    if orientation == :horizontal
      positions = (column...(column + ship.size)).map { |c| Termship::Position[row, c] }
    elsif orientation == :vertical
      positions = (row...(row + ship.size)).map { |r| Termship::Position[r, column] }
    else
      raise ArgumentError, "Invalid orientation: #{orientation}"
    end

    positions.each do |position|
      @grid[position.row][position.column] = ship
    end
  end

  # Hits the ship or water at the specified position on the board.
  #
  # @param position [Position] The position to hit.
  # @return [Ship, Symbol] Returns the ship object if a ship is hit, or :water if it's water.
  def hit(position)
    return nil if hits.include?(position)
    hits << position
    if @grid[position.row][position.column] == :water
      @grid[position.row][position.column] = :water_hit
    else
      @grid[position.row][position.column].hit!
    end
  end

  # Returns true if all ships are sunk, false otherwise.
  def all_ships_sunk?
    @grid.flatten.none? { |cell| cell.is_a?(Termship::Ship) && !cell.sunk? }
  end
end

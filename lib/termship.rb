# frozen_string_literal: true
require 'curses'
require 'logger'
require 'pry'

module Termship
  class Error < StandardError; end
  
  class << self
    attr_accessor :logger
  end
end

require_relative "termship/board"
require_relative "termship/position"
require_relative "termship/ship"
require_relative "termship/version"

board = Termship::Board.new
ships = [
  [Termship::Ship.new("Aircraft Carrier", 3), Termship::Position.new("B3"), :horizontal],
  [Termship::Ship.new("Battleship", 4), Termship::Position.new("E5"), :vertical],
  [Termship::Ship.new("Submarine", 3), Termship::Position.new("H7"), :horizontal],
  [Termship::Ship.new("Destroyer", 2), Termship::Position.new("A1"), :vertical],
  [Termship::Ship.new("Patrol Boat", 2), Termship::Position.new("D4"), :horizontal]
]
ships.each { |ship| board.place_ship(ship[0], ship[1], ship[2]) }

Curses.init_screen
Curses.start_color
Curses.init_pair(1, Curses::COLOR_WHITE, Curses::COLOR_BLUE)

# Add numbers 1 to 10 above the board
(1..10).each_with_index do |number, index|
  Curses.setpos(0, index * 2 + 2) # Adjust the starting position to account for the letters on the left
  Curses.addstr("#{number} ")
end

# Add letters A to J on the left side of the board
('A'..'J').each_with_index do |letter, index|
  Curses.setpos(index + 1, 0)
  Curses.addstr("#{letter} ")
end

hits = [] # Store the positions and results

loop do
  Curses.attron(Curses.color_pair(1)) do
    board.grid.each_with_index do |row, i|
      Curses.setpos(i + 1, 2) # Adjust the starting position to account for the letters on the left
      row.each do |cell|
        if cell == :water
          Curses.addstr('▒▓') # ▒▓
        elsif cell == :water_hit
          Curses.addstr("\u25CC ") # Large Circle Unicode Character
        else
          Curses.addstr('▒▓')
        end
      end
      Curses.addstr("\n")
    end
    board.hits.each do |hit|
      if board.grid[hit.row][hit.column].is_a?(Termship::Ship)
        Curses.setpos(hit.row + 1, hit.column * 2 + 2)
        Curses.addstr("💥")
      end
    end
  end

  # Print ships on the right side of the board
  ships.each_with_index do |ship, idx|
    Curses.setpos(idx + 1, board.grid[0].size * 2 + 4)
    ship[0].hits.times { Curses.addstr("💥") }
    (ship[0].size - ship[0].hits).times { Curses.addstr('▒▓') }
    Curses.addstr("💧") if ship[0].sunk?
  end

  Curses.refresh

  Curses.setpos(board.grid.size + 1, 0)
  Curses.addstr("Enter the next position to hit: ")
  Curses.refresh

  position = loop do
    Curses.setpos(board.grid.size + 1, 32)
    Curses.addstr(" " * 10)
    Curses.setpos(board.grid.size + 1, 32)
    pos = Curses.getstr
    break pos if Termship::Position.valid?(pos) && Termship::Position.new(pos).valid?
  end

  all_sunk = board.ships.all?(&:sunk?)
  break if all_sunk

  result = board.hit(Termship::Position.new(position))

  hits << { position: position, result: result } # Store the position and result

  # Display hits below the prompt line
  Curses.setpos(board.grid.size + 2, 0)
  hits.reverse.each do |hit|
    Curses.addstr("#{hit[:position]}: #{hit[:result].is_a?(Termship::Ship) ? '💥' : '💧'}\n")
  end

  # Clear the 2 characters entered after Curses.getstr
  Curses.setpos(board.grid.size + 1, 0)
  Curses.addstr(" " * 2)
end

Curses.close_screen

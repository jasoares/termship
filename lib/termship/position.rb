# frozen_string_literal: true

# Describes a position on the board with x and y coordinates
class Termship::Position
  attr_reader :letter, :number

  def self.[](row, col)
    letter = ('A'..'J').to_a[row]
    number = col + 1
    new("#{letter}#{number}")
  end

  def self.valid?(position)
    return false if position.nil? || position.length < 2

    true
  end

  def initialize(position)
    @letter = position[0].upcase
    @number = position[1..-1].to_i
  end

  def hash
    [letter, number].hash
  end

  def ==(other)
    self.class == other.class && [letter, number] == [other.letter, other.number]
  end
  alias eql? ==

  def row
    ('A'..'J').to_a.index(letter)
  end

  def column
    @number - 1
  end

  def valid?
    ('A'..'J').cover?(letter) && (1..10).cover?(number)
  end

  def to_s
    "(#{letter}#{number})"
  end
  alias inspect to_s
end

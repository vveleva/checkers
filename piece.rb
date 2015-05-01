require_relative 'invalid_move_error.rb'
require_relative 'multiple_routes_error.rb'
require 'byebug'
require 'matrix'

class Piece
  DIRECTIONS = { downleft:  Vector[1, -1],
                 downright: Vector[1, 1],
                 upleft:    Vector[-1, -1],
                 upright:   Vector[-1, 1] }

  attr_accessor :pos, :king
  attr_reader   :board, :color, :symbol

  def initialize(board, pos, color)
    @board, @pos, @color = board, Vector.elements(pos), color
    @king = false
    @symbol = (color == :black) ? "\u26aa" : "\u26ab"
  end

  def move(direction)
    unless move_dirs.include?(DIRECTIONS[direction])
      raise InvalidMoveError.new "Piece can't move in that direction"
    end

    new_pos = pos + DIRECTIONS[direction]

    if can_jump?(direction)
      rec_jump(direction)
    elsif can_slide?(direction)
      perform_slide(direction)
    else
      raise InvalidMoveError.new "Not a legal move"
    end
  end

  def rec_jump(direction)
    state = king
    new_direction = direction
    while can_jump?(new_direction)
      perform_jump(new_direction)
      return unless state == king
      unless can_jump?(new_direction)
        return if other_dirs(direction).empty?
        options = other_dirs(new_direction).keys.select { |k| can_jump?(k) }
        case options.length <=> 1
        when -1; break
        when 0;  new_direction = options.first
        when 1;  raise MultipleRoutesError.new "Pick a route"
        end
      end
      # prompt user if user can jump in more than one direction
    end
  end

  def perform_slide(direction)
    new_pos = pos + DIRECTIONS[direction]
    board[new_pos.to_a] = self
    board[pos.to_a] = nil
    self.pos = new_pos
    maybe_promote
  end

  def perform_jump(direction)
    new_pos = pos + DIRECTIONS[direction] * 2
    opponent_pos = pos + DIRECTIONS[direction]
    board[new_pos.to_a] = self
    board[opponent_pos.to_a] = nil
    board[pos.to_a] = nil
    self.pos = new_pos
    maybe_promote
  end


  def can_slide?(direction)
    new_pos = pos + DIRECTIONS[direction]
    return false unless check_board_at(new_pos) == :nil

    true
  end

  def can_jump?(direction)
    new_pos = pos + DIRECTIONS[direction] * 2
    opponent_pos = check_board_at(pos + DIRECTIONS[direction])
    return false unless opponent_pos == :opponent
    return false unless check_board_at(new_pos) == :nil

    true
  end

  def move_dirs
    if king
      DIRECTIONS.values
    elsif color == :white
      [DIRECTIONS[:downleft], DIRECTIONS[:downright]]
    else
      [DIRECTIONS[:upleft], DIRECTIONS[:upright]]
    end
  end

  def maybe_promote
    self.king = true if can_promote?
  end

  def can_promote?
    return true if color == :black && pos.first == 0
    return true if color == :white && pos.first == 7

    false
  end

  private

  def other_dirs(direction)
    DIRECTIONS.select { |k, v| k != direction }
  end

  def check_board_at(pos)
    x, y = pos.to_a
    if x < 0 || x > 7 || y < 0 || y > 7
      :off_board
    elsif board[pos.to_a].nil?
      :nil
    elsif board[pos.to_a].color != color
      :opponent
    else
      :ally
    end
  end

end

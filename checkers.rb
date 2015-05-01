require_relative 'board.rb'
require_relative 'invalid_move_error.rb'
require_relative 'multiple_routes_error.rb'
require_relative 'human_player.rb'
require 'pry'

class Game

  attr_reader :board, :white_player, :black_player

  def initialize(white, black)
    @board = Board.new
    board[[5, 0]].move(:upright)
    board[[2, 3]].move(:downleft)
    board[[6, 1]].move(:upleft)
    board[[1, 2]].move(:downright)
    board[[5, 6]].move(:upright)
    board[[2, 3]].move(:downright)
    board[[5, 4]].move(:upright)
    board[[0, 1]].move(:downright)
    board.render_board
    @white_player = white
    @black_player = black
  end

  def play
    player = white_player

    until game_over?(player.color)
      begin
        puts "#{player.color}'s turn."
        cur_pos, direction = player.play_turn(board)


        better_move = false
        cur_piece = board[cur_pos]
        must_move = []

        p direction
        unless cur_piece.can_jump?(direction)
          all_of_color(player.color).each do |ally|
            moves = ally.move_dirs
            moves.each do |move|
              move = Piece::DIRECTIONS.key(move)
              if ally.can_jump?(move)
                raise InvalidMoveError.new "You have a piece, which can jump"
              end
            end
          end
        end
      rescue InvalidMoveError => e
        p e.message
        retry

      rescue MultipleRoutesError => e
        p e.message
        direction = gets.chomp
      end
        board[cur_pos].move(direction)
        player = flip_turns(player)
        board.render_board
    end
  end

  def all_of_color(color)
    board.grid.flatten.compact.select { |c| c.color == color }
  end

  private

  def game_over?(color)
    all_of_color(color).empty? ? true : false
    puts ""
  end

  def flip_turns(player)
    player == white_player ? black_player : white_player
  end

end


g = Game.new(HumanPlayer.new("blah", :white), HumanPlayer.new("blah", :black))
g.play

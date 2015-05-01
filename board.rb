require_relative 'piece.rb'
require 'colorize'

class Board

  attr_reader :grid

  def initialize(empty = false)
    @grid = Array.new(8) { Array.new(8) }
    build_board
    render_board
  end

  def render_board
    puts "\e[H\e[2J"
    row_col_color = :blue
    puts ("     " + ("a".."h").to_a.join(" ")).colorize(row_col_color)
    puts ("  \u2554" + "\u2550" * 18 + "\u2557").colorize(row_col_color)

    grid.each_with_index do |row, i|
      row_string = "#{i + 1} \u2551 ".colorize(row_col_color)
      row.each_with_index do |tile, j|
        if tile.nil?
          row_string << color_tile("  ", i, j)
        else
          x, y = *(tile.pos)
          if tile.color == :black
            el = color_tile(tile.symbol.black + " ", x, y)
          else
            el = color_tile(tile.symbol.light_white + " ", x, y)
          end
          row_string << el
        end
      end

      puts row_string + " \u2551 #{i + 1}".colorize(row_col_color)
    end
    puts ("  \u255A" + "\u2550" * 18 + "\u255D").colorize(row_col_color)
    puts ("    " + ("a".."h").to_a.join(" ")).colorize(row_col_color)
    puts
  end

  def [](position)
    x, y = position
    grid[x][y]
  end

  def []=(cur_pos, new_obj)
    x, y = cur_pos
    grid[x][y] = new_obj
  end

  private

  def color_tile(str, x, y)
    if (x % 2 == 0 && y % 2 == 0) || (x % 2 == 1 && y % 2 == 1)
      str.colorize(:background => :light_blue)
    else
      str.colorize(:background => :blue)
    end
  end

  def build_board
    grid[0].each_index do |i|
      grid[0][i] = Piece.new(self, [0, i], :white) if i % 2 == 1
    end
    grid[1].each_index do |i|
      grid[1][i] = Piece.new(self, [1, i], :white) if i % 2 == 0
    end
    grid[2].each_index do |i|
      grid[2][i] = Piece.new(self, [2, i], :white) if i % 2 == 1
    end

    grid[5].each_index do |i|
      grid[5][i] = Piece.new(self, [5, i], :black) if i % 2 == 0
    end
    grid[6].each_index do |i|
      grid[6][i] = Piece.new(self, [6, i], :black) if i % 2 == 1
    end
    grid[7].each_index do |i|
      grid[7][i] = Piece.new(self, [7, i], :black) if i % 2 == 0
    end
  end

end

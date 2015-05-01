require 'byebug'

class HumanPlayer
  LETTERS_TO_NUM = ("a".."h").to_a

  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def play_turn(board)
    puts "Please enter your move."
    move = gets.chomp
    # raise NoMoveError.new "That isn't a move" unless valid_input?(move)
    arr = move.split(" ")
    y, x = arr[0].split("")
    arr[0] = [x.to_i - 1, LETTERS_TO_NUM.index(y)]
    arr[1] = arr[1].to_sym
    debugger
    arr
  end

  # def valid_input?(str)
  #   debugger
  #   chrs = str.strip.split(" ")
  #   if chrs.length != 6
  #     false
  #   elsif chrs[2] != ","
  #     false
  #   elsif !LETTERS_TO_NUM.include?(chrs[0]) || !LETTERS_TO_NUM.include?(chrs[4])
  #     false
  #   elsif chrs[1].to_i.zero? || chrs[5].to_i.zero?
  #     false
  #   elsif chrs[1].to_i > 8 || chrs[5].to_i > 8
  #     false
  #   else
  #     true
  #   end
  # end
end

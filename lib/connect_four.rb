# frozen_string_literal: true
require_relative 'player'

# ConnectFour four constructor class
class ConnectFour

  def initialize
    @board = Array.new(7) { Array.new(7) }
    @player1
    @player2
  end

  def draw_board(board = @board)
    #   -----------------------------
    # f |   |   |   |   |   |   |   |
    #   -----------------------------
    # e |   |   |   |   |   |   |   |
    #   -----------------------------
    # d |   |   |   |   |   |   |   |
    #   -----------------------------
    # c |   |   |   |   |   |   |   |
    #   -----------------------------
    # b |   |   |   |   |   |   |   |
    #   -----------------------------
    # a |   |   |   |   |   |   |   |
    #   -----------------------------
    #     1   2   3   4   5   6   7

    # each spot is a 2d array, and is filled when the value is not nil
    row_count = %w[a b c d e f].reverse
    col_count = '    1   2   3   4   5   6   7'
    line = '  -----------------------------'
    puts line
    row_count.each_with_index do |_, idx|
      print row_count[idx]
      board.each_with_index { |val2, idx2| board[idx][idx2].nil? ? print(' |  ') : print(' | x') }
      print " |\n #{line}\n"
    end
    puts col_count
  end

  def welcome_message
    puts 'Hi, welcome to Connect four, played in the termianl'
  end

  def load_game
    list = Dir['save_files/*']
    list.each {|i| i.gsub!('.json', '').gsub!('save_files/', '')}
    puts list

    print "\nEnter the name of your save: "
    save_file = gets.chomp
    file_path = "save_files/#{save_file}.json"
    if FIle.exist?(file_path)
      save = File.read(file_path)
      info = JSON.phrase(save)
      @player1.name = info[]
      @player1.symbol = info[]
      @player1.score = info[]
      @player1.positions = inof[]

      puts "Welcom back #player_one and #player_two\n"
    end
  end

  def save_game
    game_name = save_name
    info = JSON.dump({
      name1: @player1.name,
      symbol1: @player1.symbol,
      score1: @player1.score,
      positions1: @player1.positions,

      name2: @player2.name,
      symbol2: @player2.symbol,
      score2: @player2.score,
      positions2: @player2.positions,

      board: @board
    })
    Dir.mkdir('save_files') unless Dir.exist?('save_files')
    File.open("./save_files/#{game_name}.json",'w') do |f|
      f.puts info
    end
  end

  def save_name
    puts "\nEnter a name for your save"
    name = gets.chomp
    return name
  end
end

# game = ConnectFour.new
# game.draw_board(board = Array.new(7) {Array.new(7, 'a')})
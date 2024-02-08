# frozen_string_literal: true

# FIXME: fix why the game returns win on ever play
# TODO: change the Connectfour logic.
# The way the game works is that the connect four is dropped in and drops to the
# bottom of the board

require_relative './player'

# ConnectFour four constructor class
class ConnectFour
  def initialize
    @board = Array.new(7) { Array.new(7) }
    @player1
    @player2
    @turn = false
    @playing = true
    @won = false
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
    system('clc') || system('clear')
    print "\n#{@player1.name}: #{@player1.score} ===========    "
    print "#{@player2.name}: #{@player2.score}\n\n"
    row_count = %w[a b c d e f].reverse
    col_count = '    1   2   3   4   5   6   7'
    line = '  -----------------------------'
    puts line
    row_count.each_with_index do |_, idx|
      print row_count[idx]
      board.each_with_index { |val2, idx2| board[idx][idx2].nil? ? print(' |  ') : print(" | #{board[idx][idx2]}") }
      print " |\n #{line}\n"
    end
    puts col_count
  end

  def welcome_message
    puts 'Hi, welcome to Connect four, played in the termianl'
  end

  def yes_or_no(question)
    response = ''
    loop do
      print "#{question}: "
      response = gets.chomp.downcase.split('')
      break if (response & ['y','n']).any?

      puts 'Not a valid response'
    end
    response[0] == 'y' ? (return true) : (return false)
  end

  def play
    welcome_message
    create_players
    while @playing
      if @won
        yes_or_no('Keep playing(y,n)? ') ? break : nil
      @won = false
      end
      game_round
    end
  end

  def create_players
    # get player information
    print "\nEnter your name player one: "
    name1 = gets.chomp
    setsym = yes_or_no("\nDo you have a custom symbol (y,n)")
    if setsym
      print "Enter your custom symbol: "
      sym1 = gets.chomp
    else
      sym1 = choose_sym
    end

    print "\nEnter your name player two: "
    name2 = gets.chomp
    setsym = yes_or_no("\nDo you have a custom symbol (y,n)")
    if setsym
      print "Enter your custom symbol: "
      sym2 = gets.chomp
    else
      sym2 = choose_sym
    end

    # set player info
    @player1 = Player.new(name1, sym1)
    @player2 = Player.new(name2, sym2)
  end

  def game_round
    @turn = !@turn
    draw_board(@board)
    @turn ? play_turn(@player1) : play_turn(@player2)
    @turn ? @player1.score += 1 : @player2.score += 1
  end

  def play_turn(player)
    choice = valid_slot(player)
    # should change the value into an array
    # store that as player position and update board

    # convert into array of numbers
    choice = convert_choice(choice)
    # update board
    @board[choice[0]] [choice[1]] = player.symbol
    # check win
    check_win? ? @won = true : @won = false
  end

  def check_win?(board = @board)
    # check win dioganally, horizontally, vertically
    new_arr = []
    flag = false
    prev_value = ''
    for i in 0..6
      for j in 0..6
        if flag
          if board[i][j] == prev_value && !board[i][j].nil?
            new_arr << board[i][j]
          else
            new_arr = []
          end
        else
          new_arr << board[i][j]
          flag = true
        end
        if new_arr.length >= 4
          puts 'horizontal check'
          puts 'round win!!!'
          return true
        end
        prev_value = board[i][j]
      end
      flag = false
    end

    # vertically
    flag = false
    prev_value = ''
    new_arr = []
    for i in 0..6
      for j in 0..6
        if flag
          if board[j][i] == prev_value && !board[j][i].nil?
            new_arr << board[j][i]
          else
            new_arr = []
          end
        else
          new_arr << board[j][i]
          flag = true
        end
        if new_arr.length >= 4
          puts 'vertical check'
          puts 'round win!!!'
          return true
        end
        prev_value = board[j][i]
      end
      flag = false
    end

    # diagonal check
    traverse_board_diagonal_left? ? (return true) : nil
    traverse_board_diagonal_right? ? (return true): nil

    false
  end

  def traverse_board_diagonal_right?(board = @board)
    # define the size of the matrix
    row = board.length
    col = board[0].length
    i = 3
    new_arr = []
    prev_value = ''
    flag = false

    while i >= 0
      j = 0
      k = i
      while j < row && (k < col) 
        # print(" #{board[j][k]}")
        # add to array
        current = board[j][k]
        if flag
          if current == prev_value && !board[j][k].nil?
            new_arr << current
          else
            new_arr = []
          end
        else
          new_arr << current
          flag = true
        end
        if new_arr.length >= 4
          puts 'diagonal right check'
          puts 'round win!!!'
          return true
        end
        prev_value = current
        j += 1
        k += 1
      end
      # puts "\nnew_arr = #{new_arr}"
      # puts ''
      flag = false
      i -= 1
    end

    i = 3 # where the valid count starts
    while i.positive?
      j = i
      k = 0
      while j < row && k < col
        # print(" #{board[j][k]}")
        current = board[j][k]
        if flag
          current == prev_value && !board[j][k].nil? ? new_arr << current : new_arr = []
        else
          new_arr << current
          flag = true
        end
        if new_arr.length == 4
          puts 'diagonal right 2 check'
          puts 'round win!!'
        end
        # set next iteration
        prev_value = current
        j += 1
        k += 1
      end
      # puts "\nnew_arr = #{new_arr}"
      # puts ''
      flag = false
      i -= 1
    end
    false
  end

  def traverse_board_diagonal_left?(board = @board)
    # getting the size of the matrix
    row = board.length
    col = board[0].length
    i = 3
    new_arr = []
    prev_value = ''
    flag = false

    while i < col
      j = i
      while j >= 0 && (i - j < row) 
        # print(" #{board[i-j][j]}")
        # add to array
        current = board[i-j][j]
        if flag
          if current == prev_value && !board[i-j][j].nil?
            new_arr << current
          else
            new_arr = []
          end
        else
          new_arr << current
          flag = true
        end
        if new_arr.length >= 4
          puts 'diagonal left check'
          puts 'round win!!!'
          return true
        end
        prev_value = current
        j -= 1
      end
      # puts "\nnew_arr = #{new_arr}"
      # puts ''
      flag = false
      i += 1
    end

    i = 1
    while i < row - 3
      j = col - 1
      k = i
      while j.positive? && k < row
        # print(" #{board[k][j]}")
        current = board[k][j]
        if flag
          current == prev_value && !board[k][j].nil? ? new_arr << current : new_arr = []
        else
          new_arr << current
          flag = true
        end
        if new_arr.length == 4
          puts 'diagonal left 2 check'
          puts 'round win!!!'
          return true
        end
        # set next iteration
        prev_value = board[k][j]
        j -= 1
        k += 1
      end
      # puts "\nnew_arr = #{new_arr}"
      # puts ''
      flag = false
      i += 1
    end
    false
  end

  def convert_choice(value)
    new_val = []
    values = %w[f e d c b a]
    # value = [values.index(value[0]), value[1]]
    new_val << values.index(value[0])
    new_val << value[1].to_i - 1
    new_val
  end

  def valid_slot(player)
    choice = []
    loop do
      print "#{player.name} please choose a valid slot(a1, b2,...): "
      choice = gets.chomp
      choice = choice.split('')
      if choice[0].match?(/[a-f]/) && choice[1].match?(/[1-7]/)
        check = convert_choice(choice)
        if @board[check[0]][check[1]].nil?
          break
        end
      end
    end
    choice
  end
  
  def load_game
    list = Dir['save_files/*']
    list.each {|i| i.gsub!('.json', '').gsub!('save_files/', '')}
    puts list

    print "\nEnter the name of your save: "
    save_file = gets.chomp
    file_path = "save_files/#{save_file}.json"
    if File.exist?(file_path)
      save = File.read(file_path)
      info = JSON.phrase(save)
      @player1.name = info[]
      @player1.symbol = info[]
      @player1.score = info[]
      @player1.positions = inof[]

      @turn = info[turn]

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
    name
  end
end

game = ConnectFour.new
game.play
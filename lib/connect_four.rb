# frozen_string_literal: true

require_relative './player'

# ConnectFour four constructor class
class ConnectFour
  def initialize
    @board = Array.new(7) { Array.new(7) }
    @player1
    @player2
    @turn = true
    @playing = true
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
    print "\n#{@player1.name}: #{@player1.score} ==========="
    print "#{@player2.name}: #{player2.score}\n"
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
      print question
      response = gets.chomp.downcase.split('')
      break if (response & ['y','n']).any?

      puts 'Not a valid response'
    end
    response[0] == 'y' ? (return true) : (return false)
  end

  def play
    welcome_message
    create_players
    first_round = false
    while @playing
      yes_or_no('Keep playing(y,n)? ') if first_round
      first_round = true
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
    check_win?
  end

  def check_win?
    # check win dioganally, horizontally, vertically
    new_arr = []
    # horizontal_check = false
    # vetical_check = false
    # diogonal_check = false
    # horizontally
    for i in 0..6
      for j in 0..6
        if new_arr.length >= 4
          return true
        end
        if board[i][j] == board[i][j+1]
          new_arr << board[i][j]
        else
          new_arr = []
        end
      end
    end

    # vertically
    new_arr = []
    for i in 0..6
      for j in 0..6
        if new_arr.length >= 4
          return true
        end
        if board[i][j] == board[i+1][j]
          new_arr << board[i][j]
        else
          new_arr = []
        end
      end
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
        if flag
          if board[j][k] == prev_value
            new_arr << board[j][k]
          else
            new_arr = []
          end
        else
          new_arr << board[j][k]
          flag = true
        end
        if new_arr.length >= 4
          puts 'round win!!!'
          return true
        end
        prev_value = board[j][k]
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
        if flag
          board[j][k] == prev_value ? new_arr << board[j][k] : new_arr = []
        else
          new_arr << board[j][k]
          flag = true
        end
        if new_arr.length == 4
          puts 'round win!!'
        end
        # set next iteration
        prev_value = board[j][k]
        j += 1
        k += 1
      end
      # puts "\nnew_arr = #{new_arr}"
      # puts ''
      flag = false
      i -= 1
    end
  end

  def traverse_board_diagonal_left?(board)
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
        if flag
          if board[i-j][j] == prev_value
            new_arr << board[i-j][j]
          else
            new_arr = []
          end
        else
          new_arr << board[i-j][j]
          flag = true
        end
        if new_arr.length >= 4
          puts 'round win!!!'
          return true
        end
        prev_value = board[i - j][j]
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
        if flag
          board[k][j] == prev_value ? new_arr << board[k][j] : new_arr = []
        else
          new_arr << board[k][j]
          flag = true
        end
        if new_arr.length == 4
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
  end

  def convert_choice(value)
    new_val = []
    value = value.split('')
    values = %w[a b c d e f]
    # value = [values.index(value[0]), value[1]]
    new_val << values.index(value[0])
    new_val << value[1]
    new_val
  end

  def valid_slot(player)
    loop do
      print "#{player.name} please choose a valid slot(a1, b2,...): "
      choice = gets.chomp
      choice = choice.split('')
      if choice[0].match?(/[a-f]/) && choice[1].match?(/[1-7]/)
        check = convert_choice(choice)
        if @board[check[0]][check[1]].nil?
          return choice
          # break
        end
      end
    end
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
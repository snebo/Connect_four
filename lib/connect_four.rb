# frozen_string_literal: true

require_relative './player'

# ConnectFour four constructor class
class ConnectFour
  def initialize
    @board = Array.new(7) { Array.new(7) }
    @player1 = nil
    @player2 = nil
    @turn = false
    @playing = true
    @won = false
  end

  def draw_board(board = @board)
    system('clc') || system('clear')
    print "\n#{@player1.name}: #{@player1.score} ===========    "
    print "#{@player2.name}: #{@player2.score}\n\n"
    row_count = %w[a b c d e f].reverse
    col_count = '    1   2   3   4   5   6   7'
    line = '  -----------------------------'
    puts line
    row_count.each_with_index do |_, idx|
      print row_count[idx]
      board.each_with_index { |_, idx2| board[idx][idx2].nil? ? print(' |  ') : print(" | #{board[idx][idx2]}") }
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
      break if (response & %w[y n]).any?

      puts 'Not a valid response'
    end
    response[0] == 'y' ? (return true) : (return false)
  end

  def play
    welcome_message
    create_players
    while @playing
      @won ? (break if yes_or_no('Keep playing(y,n)? ')) : game_round
    end
  end

  def create_players
    # get player information
    print "\nEnter your name player one: "
    name1 = gets.chomp
    setsym = yes_or_no("\nDo you have a custom symbol (y,n)")
    if setsym
      print 'Enter your custom symbol: '
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

    # # convert into array of numbers
    choice = convert_choice(choice)
    # update board
    update_board(choice, player)
    # check win
    @won = check_win? ? true : false
  end

  def update_board(choice, player)
    while choice[0] < 5 && @board[choice[0] + 1][choice[1]].nil?
      # why does this ignore nil values?????
      choice[0] += 1
    end
    @board[choice[0]][choice[1]] = player.symbol
  end

  def check_win?(board = @board)
    puts 'checking'
    # check win dioganally, horizontally, vertically
    new_arr = []
    flag = false
    prev_value = ''

    board.each_with_index do |_, i|
      board[i].each do |val|
        curr = val
        if flag
          if curr == prev_value && !curr.nil?
            new_arr << curr
          else
            new_arr = []
            # new_arr << curr
          end
        else
          prev_value = curr
          new_arr << curr
          flag = true
        end
        if new_arr.length == 4
          puts new_arr
          puts 'horizontal check'
          puts 'round win!!!'
          return true
        end
        prev_value = curr
      end
      flag = false
    end

    # vertically
    flag = false
    prev_value = ''
    new_arr = []

    board.each_with_index do |_, i|
      board[i].each_with_index do |_,j|
        curr = board[j][i]
        if flag
          if curr == prev_value && !curr.nil?
            new_arr.push(curr)
          else
            new_arr = []
            new_arr << curr
          end
        else
          new_arr << curr
          flag = true
        end
        if new_arr.length >= 4
          p new_arr
          puts 'vertical check'
          puts 'round win!!!'
          return true
        end
        prev_value = curr
      end
      flag = false
    end

    # diagonal check
    traverse_board_diagonal_left?(board) ? (return true) : nil
    traverse_board_diagonal_right?(board) ? (return true): nil

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
          if current == prev_value.to_s && !board[j][k].nil?
            new_arr << current
          else
            new_arr = []
            # new_arr << current
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
          if current == prev_value && !board[j][k].nil?
            new_arr << current
          else
            new_arr = []
          end
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
    start_at = 3
    new_arr = []
    prev_value = ''
    flag = false

    while start_at < col
      j = start_at
      i = 0
      while i < row && j >= 0
        # print "#{board[i][j]} "
        current = board[i][j]
        if flag
          if current == prev_value
            new_arr << current unless current.nil?
          else
            new_arr = []
          end
        else
          new_arr << current
          flag = true
        end
        if new_arr.length >= 4
          puts new_arr
          puts 'diagonal left check'
          puts 'round win!!!'
          return true
        end
        prev_value = current
        i += 1
        j -= 1
      end
      start_at += 1
    end

    i = 1
    while i < row - 3
      j = col - 1
      k = i
      while j.positive? && k < row
        # print(" #{board[k][j]}")
        current = board[k][j]
        if flag
          if current == prev_value && !board[k][j].nil?
            new_arr << current
          else
            new_arr = []
            new_arr.push(current)
          end
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
        prev_value = current
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
        break if @board[check[0]][check[1]].nil?
      end
    end
    choice
  end
  
  def load_game
    list = Dir['save_files/*']
    list.each { |i| i.gsub!('.json', '').gsub!('save_files/', '') }
    puts list

    print "\nEnter the name of your save: "
    save_file = gets.chomp
    file_path = "save_files/#{save_file}.json"
    return 'file not found' if File.exist?(file_path)

    save = File.read(file_path)
    info = JSON.phrase(save)
    @player1.name = info[]
    @player1.symbol = info[]
    @player1.score = info[]
    @player1.positions = inof[]

    @turn = info[turn]

    puts "Welcom back #player_one and #player_two\n"
  end

  def save_game
    game_name = save_name
    info = JSON.dump({  name1: @player1.name,
                        symbol1: @player1.symbol,
                        score1: @player1.score,
                        positions1: @player1.positions,

                        name2: @player2.name,
                        symbol2: @player2.symbol,
                        score2: @player2.score,
                        positions2: @player2.positions,

                        board: @board })
    Dir.mkdir('save_files') unless Dir.exist?('save_files')
    File.open("./save_files/#{game_name}.json", 'w') do |f|
      f.puts info
    end
  end

  def save_name
    puts "\nEnter a name for your save: "
    name = gets.chomp
    puts "file has been saved as #{name}.json"
  end

  def horizontal_check(board, new_arr = [], prev = '')
    board.each_with_index do |_, i|
      board[i].each do |val|
        curr = val
        curr == prev ? new_arr << curr : new_arr.clear.push(curr)
        prev = curr
        return true if new_arr.length == 4
      end
      prev = ''
    end
  end

  def vertical_check(board, new_arr = [], prev = '')
    board.each_with_index do |_, i|
      board[i].each_with_index do |_, j|
        curr = board[j][i]
        curr == prev ? new_arr << curr : new_arr.clear.push(curr)
        prev = curr
        return true if new_arr.length == 4
      end
      prev = ''
    end
  end

  def diagonal_check_left(board, limit, new_arr = [], prev = '')
    start_at = limit
    while start_at < board[0].length
      i = 0; j = start_at
      while i < board.length && j >= 0
        curr = board[i][j]
        curr == prev ? new_arr << curr : new_arr.clear.push(curr)
        prev = curr
        return true if new_arr.length == 4

        i += 1; j -= 1
      end
      prev = ''; start_at += 1
    end
    start_at = 1
    while start_at < board[0].length - limit
      j = 6; i = start_at
      while j >= 0 && i < board.length
        curr = board[i][j]
        curr == prev ? new_arr << curr : new_arr.clear.push(curr)
        prev = curr
        return true if new_arr.length == 4

        j -= 1; i += 1
      end
      prev = ''; start_at += 1
    end
  end

  def diagonal_check_right(board, limit, new_arr = [], prev = '')
    #  i  j
    # [3][0], [2][1]
    start_at = limit
    while start_at >= 0
      i = start_at
      j = 0
      while j < board[0].length && i < board.length
        curr = board[i][j]
        curr == prev ? new_arr << curr : new_arr.clear.push(curr)
        prev = curr
        return true if new_arr.length == 4

        j += 1; i += 1
      end
      prev = ''; start_at -= 1
    end

    start_at = 1
    while start_at < board[0].length - limit
      i = 0; j = start_at
      while j < board.length
        curr = board[i][j]
        curr == prev ? new_arr << curr : new_arr.clear.push(curr)
        prev = curr
        return true if new_arr.length == 4
        
        i += 1; j += 1
      end
      prev = ''; start_at += 1
    end
  end

  def check_board(board = @board)
    horizontal_check(board)
    vertical_check(board)
    diagonal_check_left(board, 3)
    diagonal_check_right(board, 3)
  end

end

game = ConnectFour.new
# game.play
x_board = [%w[@ @ # ^ & M A],
           %w[A D @ B # A &],
           %w[X O X $ M B &],
           %w[@ @ # ^ & M A],
           %w[A D @ B # A &],
           %w[X O X $ M B &],
           %w[@ @ # ^ & M A]]
#  i  j
# [0][1], [1][2]
game.check_board(x_board)

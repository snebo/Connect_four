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
      if @won
        yes_or_no('Keep playing (y,n)?: ') ? @won = false : @playing = false
        @board = Array.new(7) { Array.new(7) } # reset board
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
    puts check_board?(@board)
    @won = check_board? ? true : false
  end

  def update_board(choice, player)
    while choice[0] < 5 && @board[choice[0] + 1][choice[1]].nil?
      # why does this ignore nil values?????
      choice[0] += 1
    end
    @board[choice[0]][choice[1]] = player.symbol
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
        next if curr.nil? # added
        curr == prev ? new_arr << curr : new_arr.clear.push(curr)
        prev = curr
        return true if new_arr.length == 4
      end
      prev = ''
    end
    false
  end

  def vertical_check(board, new_arr = [], prev = '')
    board.each_with_index do |_, i|
      board[i].each_with_index do |_, j|
        curr = board[j][i]
        next if curr.nil? # added
        curr == prev ? new_arr << curr : new_arr.clear.push(curr)
        prev = curr
        return true if new_arr.length == 4
      end
      prev = ''
    end
    false
  end

  def diagonal_check_left(board, limit, new_arr = [], prev = '')
    start_at = limit
    while start_at < board[0].length
      i = 0; j = start_at
      while i < board.length && j >= 0
        curr = board[i][j]
        if !curr.nil?
          curr == prev ? new_arr << curr : new_arr.clear.push(curr)
          prev = curr
        end
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
        if !curr.nil?
          curr == prev ? new_arr << curr : new_arr.clear.push(curr)
          prev = curr
        end
        return true if new_arr.length == 4

        j -= 1; i += 1
      end
      prev = ''; start_at += 1
    end
    false
  end

  def diagonal_check_right(board, limit, new_arr = [], prev = '')
    start_at = limit
    while start_at >= 0
      i = start_at
      j = 0
      while j < board[0].length && i < board.length
        curr = board[i][j]
        if !curr.nil?
          curr == prev ? new_arr << curr : new_arr.clear.push(curr)
          prev = curr
        end
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
        if !curr.nil?
          curr == prev ? new_arr << curr : new_arr.clear.push(curr)
          prev = curr
        end
        return true if new_arr.length == 4

        i += 1; j += 1
      end
      prev = ''; start_at += 1
    end
    false
  end

  def check_board?(board = @board)
    check = [horizontal_check(board),
             vertical_check(board),
             diagonal_check_left(board, 3),
             diagonal_check_right(board, 3)]
    check.any?
  end
end

game = ConnectFour.new
game.play
# x_board = [[1,3,5,6,7,8,3],
#            [2,5,7,3,5,1,6],
#            [7,1,7,7,8,2,1],
#            [7,3,5,6,7,7,3],
#            [2,5,7,3,7,1,6],
#            [5,3,7,5,8,2,1],
#            [5,3,7,7,8,2,1]]

# game.check_board?

class Connect_four

  def initialize
    board = Array.new(7) {Array.new(7)}
  end

  def drawBoard(board)
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
    row_count = %w[a b c d e f]
    col_count = '    1   2   3   4   5   6   7'
    line = '  -----------------------------'
    puts line
    for i in 1..row_count.length
      print row_count[ row_count.length - i]
      for j in 0..board.length - 1
        board[i][j].nil? ? print(' |  ') : print(' | x')
      end
      print " |\n"
      puts line
    end
    puts col_count
  end
end

game = Connect_four.new
game.drawBoard(board = Array.new(7) {Array.new(7, 'a')})

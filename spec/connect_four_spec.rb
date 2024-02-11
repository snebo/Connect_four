# frozen_string_literal: true

require_relative '../lib/connect_four'
require_relative '../lib/player'

describe ConnectFour do
  subject(:game) {described_class.new}
  let(:player) {Player.new('example', 'X')}

  describe 'initialize' do
    it 'returns welcome message' do
      message = "Hi, welcome to Connect four, played in the termianl\n"
      expect{ game.welcome_message }.to output(message).to_stdout
    end
    it 'player information gets called' do
      game.player1 = player
      expect(game.player1.name).to eq('example')
      expect(game.player1.symbol).to eq('X')
    end
    it 'creates an empty board' do
      empty_arr = Array.new(7) { Array.new(7)}
      my_board = game.board
      expect(my_board).to eq(empty_arr)
    end
    it 'board is empty' do
      expect(game.board.all?(true)).to eq(false)
    end
  end

  describe 'win conditions' do
    x_board = [[1, 3, 5, 6, 7, 8, 3],
               [2, 5, 7, 3, 5, 1, 6],
               [7, 1, 7, 7, 7, 7, 1],
               [7, 3, 5, 6, 7, 1, 3],
               [7, 7, 7, 3, 1, 1, 6],
               [7, 3, 7, 1, 5, 2, 1],
               [5, 3, 7, 7, 8, 2, 1]]

    empty_arr = Array.new(7) { Array.new(7)}
    context 'horizontal check' do
      it 'horizontal win' do
        hor_win_check = game.horizontal_check(x_board)
        expect(hor_win_check).to be true
      end
      it 'horizontal loss' do
        hor_loss_check = game.horizontal_check(empty_arr)
        expect(hor_loss_check).to be false
      end
    end

    context 'vertical check' do
      it 'vertical win' do
        ver_win_check = game.vertical_check(x_board)
        expect(ver_win_check).to be true
      end
      it 'vertical loss' do
        ver_loss_check = game.vertical_check(empty_arr)
        expect(ver_loss_check).to be false
      end
    end

    context 'diagonal check left' do
      it 'diagonal left win' do
        diag_l_win_check = game.diagonal_check_left(x_board, 3)
        expect(diag_l_win_check).to be true
      end
      it 'diagonal left loss' do
        diag_l_loss_check = game.diagonal_check_left(empty_arr, 3)
        expect(diag_l_loss_check).to be false
      end
    end

    context 'diagonal check right' do
      it 'diagonal right win' do
        diag_r_win_check = game.diagonal_check_right(x_board, 3)
        expect(diag_r_win_check).to be true
      end
      it 'diagonal right loss' do
        diag_r_loss_check = game.diagonal_check_right(empty_arr, 3)
        expect(diag_r_loss_check).to be false
      end
    end
    
    it 'game win' do
      expect(game.check_board?(x_board)).to be true
    end
    it 'game loss' do
      expect(game.check_board?(empty_arr)).to be false
    end
  end
  
end

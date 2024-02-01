# frozen_string_literal: true

require_relative '../lib/connect_four'

describe ConnectFour do 
  subject(:game) {described_class.new}

  describe 'initialize' do 
    context 'welcome message gets printed' do 
      it 'returns welcome message' do\
        message = "Hi, welcome to Connect four, played in the termianl\n"
        expect{game.welcome_message}.to output(message).to_stdout
      end
      it 'player information gets called' do
        expect(game.player1.name).to eq
      end
    end
  end
end
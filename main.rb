# frozen_string_literal: true

require_relative 'players.rb'
require_relative 'pieces.rb'
require_relative 'game.rb'
require_relative 'squares.rb'
require 'colorize'
require 'pry-byebug'

def play_game
  game = Game.new
  game.game_prep
  loop do
    game.turns
    break if game.victory
    break if game
             .end
  end

  play_game
end

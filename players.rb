# frozen_string_literal: true

class Player
  def initialize(name, color)
    @name = name
    @color = color
  end
  attr_reader :name, :color
end

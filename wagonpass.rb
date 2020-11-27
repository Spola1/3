# frozen_string_literal: true

class WagonPass < Wagon
  attr_reader :free_seats
  def initialize(id, number_of_places = 28)
    @type = 'Пассажирский'
    super
  end

  def take_seats
    raise 'Нет свободных мест!' if @occuped == @capacity
    @occuped += 1
  end

  def free_seatss
    raise 'Все места свободны!' if @occuped.zero?
    @occuped -= 1
  end
end

# frozen_string_literal: true

class Wagon
  
  attr_reader :id, :type
  attr_accessor :train_number, :capacity, :occuped

  include Company
  include Validation

  ID_CARRIAGE = /^\d+$/

  validate :id, presence: true, format: ID_CARRIAGE

  def initialize(id, capacity)
    @id = id
    @capacity = capacity
    @occuped = 0
    @train_number = nil
    check!
  end

  def attached?
    @train_number != nil
  end

  def avaliable
    @capacity - @occupied
  end

  private

  def check!
    raise 'Неверный формат номера' if @id.to_s
  end
end

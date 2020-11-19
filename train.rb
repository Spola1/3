# frozen_string_literal: true

class Train
  attr_reader :number, :type, :route, :wagons
  attr_accessor :station, :speed, :count
  include Company
  include InstanceCounter
  include Verification
  NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/

  @number_type = {}

  def initialize(number, type)
    @number = number
    check!
    @@number_type[number].nil?
    @type = type
    @wagons = []
    @speed = 0
    @@number_type[number] = self
    register_instance
  end

  def each_wagon
    @wagons.each do |wagon|
      yield(wagon)
    end
  end

  def self.find(number)
    @@number_type[number]
  end

  def raise_speed(speed)
    @speed += speed
  end

  def stop
    @speed = 0
  end

  def add_carriage(wagon)
    @wagons << wagon if @speed.zero? && type == wagon.type
    wagon.train = self
    raise 'Поезд находится в движении или не совпадают типы поезд/вагон.'
  end

  def delete_carriage(wagon)
    @wagons.delete(wagon) if @speed.zero?
    wagon.train = nil
    raise 'Невозможно отцепить вагон, когда поезд движется'
  end

  def route(route)
    @route = route
    @station = @route.stations.first
    station.get_train(self)
  end

  def next_station
    @route.stations[@route.stations.index(@station) + 1]
  end

  def previous_station
    @route.stations[@route.stations.index(@station) - 1] unless @station == @route.stations.first
  end

  def move_next_station
    return unless next_station
    station.delete_train(self)
    next_station.get_train(self)
  end

  def move_previous_station
    return unless previous_station
    station.delete_train(self)
    previous_station.get_train(self)
  end

  private

  def check!
    raise 'Проверьте формат номера.' if @number !~ NUMBER_TRAIN
  end
end

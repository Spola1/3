# frozen_string_literal: true

class Route
  attr_reader :stations, :name
  include InstanceCounter

  def initialize(start_station, finish_station)
    @stations = [start_station, finish_station]
    check!
    register_instance
  end

  def stations_match?
    stations.first == stations.last || stations.first.name == stations.last.name
  end

  def stations_name
    stations.first.name + '-' + stations.last.name
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def stations_list
    stations.each.with_index(1) do |station, index|
      puts "#{index}.#{station.name}"
    end
  end

  def delete_station(station)
    return unless (@stations.first || @stations.last) != station
    @stations.delete(station)
  end

  private

  def check!
    raise 'В маршруте должно быть минимм 2 станции' if @stations.lenght < 2
  end
end

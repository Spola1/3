# frozen_string_literal: true

class Menu
  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/BlockLength

  def start
    loop do
      puts 'Выберите действие:'
      puts '1.Создать станцию'
      puts '2.Создать поезд'
      puts '3.Создать маршрут'
      puts '4.Изменить маршрут'
      puts '5.Назначить маршрут поезду'
      puts '6.Добавить вагоны'
      puts '7.Отцепиить вагоны'
      puts '8.Переместить поезд'
      puts '9.Занять место\объем в вагоне'
      puts '10.Посмотреть список станций'
      puts '0.Выход'
      choise = gets.chomp.to_i
      case choise
      when 1
        create_station
      when 2
        create_train
      when 3
        create_route
      when 4
        change_route
      when 5
        set_route_to_train
      when 6
        add_wagons
      when 7
        delete_wagons
      when 8
        move_train
      when 9
        teke_place_in_wagon
      when 10
        info
      when 0
        break
      end
    end
  end

  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/BlockLength

  protected

  def all_stations
    @stations.each do |station, index|
      puts "#{index}. #{station.name}}"
    end
  end

  def all_routes
    @routes.each do |route, index|
      puts "#{index}. #{route.name}"
    end
  end

  def all_trains
    @trains.each do |trains, _number, index|
      puts "#{index}. Номер поезда - #{trains.number}, тип - #{trains.type}"
    end
  end

  # rubocop:disable Metrics/LineLength

  def all_free_wagons_list
    @wagons.reject { |wagon| wagon.train.nil? }.each.with_index(1) do |wagon, index|
      puts "#{index}.id - #{wagon.id}, тип - #{wagon.type}."
    end
  end

  # rubocop:enable Metrics/LineLength:

  def single_train_wagons_list
    @wagons.each_with_index(1) do |wagon, index|
      puts "#{index}. id вагона - #{wagon.id}, тип вагона - #{wagon.type}"
    end
  end

  def select_train
    puts 'Выберите поезд:'
    all_trains
    index = gets.to_i
    @train = @trains[index - 1]
  end

  def create_station
    puts 'Введите название станции: '
    name_of_station = gets.to_s
    @stations << Station.new(name_of_station)
    puts "Создана новая станция - #{name_of_station}"
  rescue RuntimeError => e
    puts "Ошибка: #{e.message}"
    retry
  end

  def create_train
    begin
      puts "Ведите тип поезда:\n\t1.Грузовой\n\t2.Пассажирский"
      type = gets.to_i
      puts 'Введите номер поезда (3 символа -необязательный дефис-2 символа)'
      number = gets.to_i
      train = if type == 1
                CargoTrain.new(number)
              else
                PassengerTrain.new(number)
              end
      @trains << train
    rescue RuntimeError => e
      puts "Ошибка: #{e.message}"
      retry
    end
    puts "Создан новый поезд. Номер - #{train.number}, тип - #{train.type}"
  end

  def create_route
    begin
      puts 'Выберите начальную станцию:'
      all_stations
      index = gets.to_i
      start_station = @stations[index - 1]
      puts 'Выберите конечную станцию:'
      all_stations
      index = gets.to_i
      finish_station = @stations[index - 1]
      route = Route.new(start_station, finish_station)
    rescue RuntimeError => e
      puts "Ошибка: #{e.message}"
      retry
    end
    @routes << route
    puts "Маршрут: #{route.stations.first.name} - #{route.stations.last.name}"
  end

  def change_route
    puts 'Выберите маршрут для изменения:'
    all_routes
    index = gets.to_i
    route = @routes[index - 1]
    puts "1.Удалить станцию\n2.Добавить станцию"
    choice = gets.to_i
    case choice
    when 1
      puts 'Какую станцию удалить?'
      route.stations_list
      index = gets.to_i
      station = @stations[index - 1]
      route.delete_station(station)
    when 2
      puts 'Какую станцию добавить в маршрут?'
      all_stations
      index = gets.to_i
      station = @stations[index - 1]
      route.add_station(station)
    end
  end

  def set_route_to_train
    select_train
    puts 'Выберите маршрут:'
    all_routes
    index = gets.to_i
    route = @routes[index - 1]
    @train.route(route)
  end

  def create_wagon
    puts 'Введите id вагона: '
    id = gets.to_i
    puts "Введите тип вагона \n\t1.Грузовой \n\t2.Пассажирский"
    type = gets.to_i
    if type == 1
      puts 'Введите общий объем вагона: '
      capacity = gets.to_i
      wagon = WagonCargo.new(id, capacity)
      @wagons << wagon
      wagon
    else
      puts 'Введите общее количество мест в вагоне: '
      number_of_places = gets.to_i
      wagon = WagonPass.new(id, number_of_places)
      @wagons << wagon
    end
    wagon
  rescue RuntimeError => e
    puts "Ошибка #{e.message}"
    retry
  end
end

def add_wagons
  select_train
  puts 'Создайте вагон'
  wagon = create_wagon
  @train.add_carriage(wagon)
end

def delete_wagons
  select_train
  puts 'Список вагонов поезда. Выберите какой нужно отцепить: '
  @train.wagons.each.with_index(1) do |wagon, index|
    puts "#{index}. #{wagon.id}, #{wagon.type}."
  end
  index = gets.to_i
  wagon = @train.wagons[index - 1]
  @train.delete_carriage(wagon)
end

def move_train
  select_train
  puts "Выберите направление:\n\t1.Вперед\n\t2.Назад"
  choise = gets.to_i
  if choise == 1
    @train.move_next_station
  elsif choise == 2
    @train.move_previous_station
  end
end

def info
  puts "Показать информацию о\n\t1.Станции\n\t2.Поезде"
  choice = gets.to_i
  case choice
  when 1
    choise_1
  when 2
    choise_2
  end
end

def choise_1
  puts "Список всех станций.\nВыберите станцию для просмотра информации:"
  all_stations
  index = gets.to_i
  station = @stations[index - 1]
  raise 'На этой станции нет поездов' if station.trains.empty?

  station.each_train { |train| }
  puts "Номер поезда - #{train.number}, тип - #{train.type},\
  кол-во вагонов - #{train.wagons.size}"
end

# rubocop:disable Metrics/LineLength

def choise_2
  puts "Список всех поездов.\nВыберите вагон для просмотра информации: "
  all_trains
  index = gets.to_i
  train = @trains[index - 1]
  raise 'У этого поезда нет вагонов' if train.wagons.empty?

  train.each_wagon { |wagon| }
  puts "ID вагона - #{wagon.id}, тип - #{wagon.type}\
  #{wagon.type == 'Пассажирский' ? "Свободных мест #{wagon.avaliable} Занятых мест #{wagon.occupied}" : "Свободный объем #{wagon.avaliable}, Занятый объем #{wagon.occupied}"}"
end

# rubocop:enable Metrics/LineLength

def teke_place_in_wagon
  puts 'Выберите поезд: '
  all_trains
  index = gets.to_i
  train = trains[index - 1]
  puts 'Выберите вагон, чтобы занять место: '
  single_train_wagons_list
  index = gets.to_i
  wagon = wagons[index - 1]
  if wagon.type == 'Пассажирский'
    passenger_wagon
  elsif wagon.type == 'Грузовой'
    cargo_wagon
  end

  def cargo_wagon
    puts "Какой объем занять?, доступно - #{wagon.capacity}"
    cargo_volume = gets.to_i
    wagon.upload(cargo_volume)
    puts "Был занят объем - #{cargo_volume}, осталось - #{wagon.avaliable}"
  end

  def passenger_wagon
    puts 'Занять место?(y/n)'
    choise = gets.to_s
    wagon.take_seats if choise == 'y'
    puts "Занято одно место, осталось #{wagon.free_seats}."
  end
end

class Menu

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def start
    loop do
      puts "Выберите действие: \n\t1.Создать станцию \n\t2.Создать поезд \n\t3.Создать маршрут \n\t4.Изменить маршрут \n\t5.Назначить маршрут поезду \n\t6.Добавить вагоны \n\t7.Отцепиить вагоны \n\t8.Переместить поезд \n\t9.Посмотреть список станций \n\t0.Выход"
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
        info
      when 0
        break
      end
    end
  end

protected
# потому что все необходимое пользователю - это меню выше

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
    @trains.each do |trains, number, index|
      puts "#{index}. Номер поезда - #{trains.number}, тип - #{trains.type}"
    end
  end

  def all_free_wagons_list
     @wagons.reject { |wagon| wagon.train == nil }.each.with_index(1) do |wagon, index|
       puts "#{index}.id - #{wagon.id}, тип - #{wagon.type}."
     end
   end

  def select_train
    puts 'Выберите поезд:'
    all_trains
    index = gets.to_i
    @train = @trains[index - 1]
  end

  def create_station
    puts "Введите название станции: "
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
      puts 'Введите номер поезда в формате (три буквы или цифры в любом порядке-необязательный дефис-две буквы или цифры после дефиса)'
      number = gets.to_i
      if type == 1
        train = CargoTrain.new(number)
      else
        train = PassengerTrain.new(number)
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
    puts "Создан маршрут #{route.stations.first.name} - #{route.stations.last.name}"
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
    route = @routes[index -1]
    @train.route(route)
 end

 def create_wagon
   puts 'Введите id вагона: '
   id = gets.to_i
   puts "Введите тип вагона \n\t1.Грузовой \n\t2.Пассажирский"
   type = gets.to_i
   if type == 1
     wagon = WagonCargo.new(id)
     @wagons << wagon
     wagon
   else
     wagon = WagonPass.new(id)
     @wagons << wagon
     wagon
   end
 rescue RuntimeError => e
    puts "Ошибка #{e.message}"
    retry
  end
  puts "Создан вагон: #{wagon.id}. #{wagon.type}"
 end

 def add_wagons
   select_train
   puts "Создайте вагон"
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
  choise_1 = gets.to_i
    if choise_1 == 1
      @train.move_next_station
    elsif choise_1 == 2
      @train.move_previous_station
    end
  end

  def info
   puts "Список всех станций.\nВыберите станцию для просмотра дополнительной информации:"
   all_stations
   index = gets.to_i
   station = @stations[index - 1]
   if station.trains.empty?
     raise 'На этой станции нет поездов'
   else
     station.trains.each do |train|
       puts "Номер поезда: #{train.number}. Тип поезда: #{train.type}"
     end
   end
 end
end
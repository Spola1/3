require_relative 'menu'
require_relative 'varification'
require_relative 'company'
require_relative 'instanse_counter'
require_relative 'accessors'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagoncargo'
require_relative 'wagonpass'

controller = Menu.new
controller.start

require 'sinatra'
require 'sinatra/activerecord'
require 'pony'
require 'debugger'
require 'json'
require 'timezone'
require 'rack-flash'
require 'bcrypt'
require './env'

require_relative './helpers/helpers'
require_relative './controllers/user_controller'
require_relative './controllers/circle_controller'
require_relative './controllers/task_controller'
require_relative './controllers/alert_controller'


require_relative './models/task'
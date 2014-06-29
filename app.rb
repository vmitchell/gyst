require 'sinatra'
require 'sinatra/activerecord'
require './env'

require_relative './helpers/helpers'
require_relative './controllers/user_controller'
require_relative './controllers/circle_controller'
require_relative './controllers/task_controller'
require_relative './controllers/alert_controller'

require_relative './models/task'
require 'rubygems'
require 'bundler/setup'
require 'pg'

require 'active_support/all'

# Load Sinatra Framework (with AR)
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/contrib/all' # Requires cookies, among other things
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'rmagick'
require 'bcrypt'
require 'geocoder'

require_relative '../app/uploaders/image_uploader'

require 'pry' if development?

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

# Sinatra configuration
configure do
  set :root, APP_ROOT.to_path
  set :server, :puma

  enable :sessions
  set :session_secret, ENV['SESSION_KEY'] || 'lighthouselabssecret'

  set :views, File.join(Sinatra::Application.root, "app", "views")
end

# Geocoder configuration
Geocoder.configure(
  # set default units to kilometers:
  :units => :km,
)

CarrierWave.configure do |config|
   config.root = APP_ROOT + 'public/'
end

# Set up the database and models
require APP_ROOT.join('config', 'database')

# Load the routes / actions
require APP_ROOT.join('app', 'actions')

ActiveRecord::Base.raise_in_transactional_callbacks = true
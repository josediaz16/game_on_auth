require_relative 'config/application'

GameOnAuth::Application.finalize!

run GameOnAuth::Web.app

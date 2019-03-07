require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

#Pry::ColorPrinter.pp(obj)
#ActiveRecord::Base.logger = nil # gets rid of SQL statement

require 'open-uri'

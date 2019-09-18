require 'mysql2'
require './database_connect'

class Attendance
  def initialize
    #initializing connection
    @client = Database.new
  end 
end
Attendance.new


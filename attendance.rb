require 'mysql2'
require './database_connect'

class Attendance
  def initialize
    #initializing connection
    @client = Database.new
  end
  
  #listing the Employee information in the database
  def list
    @client.list_employee
  end
  
  


end #end_of_class
a = Attendance.new
a.list


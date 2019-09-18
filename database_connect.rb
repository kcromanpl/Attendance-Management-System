require 'mysql2'
require 'pry'


class Database
  def initialize
   #initializes the Mysql connection 
    begin
      @client =   Mysql2::Client.new(:host => "localhost", :username => "Roman", :password => "Roman123", :database => "employees_reports")
      @client.query("
        CREATE TABLE IF NOT EXISTS employees(
        emp_id INT PRIMARY KEY,
        name VARCHAR(30) NOT NULL, 
        address VARCHAR(30) NOT NULL, 
        phone VARCHAR(20) NOT NULL, 
        depatment VARCHAR(20) NOT NULL, 
        present TINYINT(1) NOT NULL)
        ")
    rescue => e
      puts "Error connecting to database"
      puts e.message
    end
  end
end #end_of_class
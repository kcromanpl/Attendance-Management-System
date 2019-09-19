require 'mysql2'
require 'pry'

class Database
  def self.create_con
    Mysql2::Client.new(:host => "localhost", :username => "Roman", :password => "Roman123", :database => "employees_reports")
  end
  def initialize
    @client = Mysql2::Client.new(:host => "localhost", :username => "Roman", :password => "Roman123", :database => "tests")
    @client.query("
      CREATE TABLE IF NOT EXISTS employees(
      emp_id INT PRIMARY KEY,
      name VARCHAR(30) NOT NULL, 
      address VARCHAR(30) NOT NULL, 
      phone VARCHAR(20) NOT NULL, 
      department VARCHAR(20) NOT NULL, 
      present TINYINT(1) NOT NULL)
      ")
      #table - employees_pin
      @client.query("
        CREATE TABLE IF NOT EXISTS employees_pin(
        pin_id INT PRIMARY KEY,
        emp_id INT NOT NULL,
        pin INT(4),
        FOREIGN KEY(emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE ON UPDATE CASCADE )
        ")
      #table - employees_time
      @client.query("
      CREATE TABLE IF NOT EXISTS employees_time(
        time_id INT PRIMARY KEY,
        emp_id INT NOT NULL,
        date DATE,
        arrival_time DATETIME,
        depart_time DATETIME,
        FOREIGN KEY(emp_id) REFERENCES employees(emp_id) on delete cascade on update cascade)
        ")
    rescue => e
    puts "Error connecting to database"
    puts e.message
  end
end
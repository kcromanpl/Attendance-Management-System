require "mysql2"
require "pry"

class Database
  #creating connection
  # def self.create_con
  #   Mysql2::Client.new(:host => "localhost", :username => "Roman", :password => "Roman123", :database => "employees_reports")
  # end
  # def self.close_con
  #   Database.create_con.close
  # end

  def initialize
    begin
      @client = Mysql2::Client.new(:host => "localhost", :username => "Roman", :password => "Roman123", :database => "employees_reports")
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
        pin_id INT AUTO_INCREMENT PRIMARY KEY,
        emp_id INT NOT NULL,
        pin INT(4),
        FOREIGN KEY(emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE ON UPDATE CASCADE )
        ")
      #table - employees_time
      @client.query("
      CREATE TABLE IF NOT EXISTS employees_time(
        time_id INT AUTO_INCREMENT PRIMARY KEY,
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

  #account_check
  def account_check_employee
    begin
      result_set = @client.query("SELECT * FROM employees")
    rescue => e
      puts "Account Check Failed - Database Error!"
      puts e.message
    end
  end

  #pin_check
  def pin_check_employee(emp_id)
    begin
      pin_set = @client.query("SELECT pin FROM employees_pin where emp_id = '#{emp_id}' ") 
    rescue => e
      puts "Pin check failed - Database Error !!"
      e.message
    end
  end

  #listing the employee records
  def list_employee
    begin
      @result_set = @client.query("SELECT * FROM employees")
    rescue => e
      puts "Listing Failed - Database Error"
      puts e.message
    end
  end

  #listing the employee records
  def list_pin_employee
    begin
      emp_pin_set = @client.query("SELECT * FROM employees_pin")
    rescue => e
      puts "Listing Failed - Database Error"
      puts e.message
    end
  end

  #listing the employee records
  def list_time_employee
    begin
      emp_time_set = @client.query("SELECT * FROM employees_time")
    rescue => e
      puts "Listing Failed - Database Error"
      puts e.message
    end
  end

  #inserting Employee details in the information
  def insert_employee(new_emp_id, name, address, phone, department, present, pin)
    begin
      @client.query("INSERT INTO employees VALUES('#{new_emp_id}','#{name}','#{address}','#{phone}','#{department}','#{present}') ")
      @client.query("INSERT INTO employees_pin(emp_id,pin)  VALUES('#{new_emp_id}','#{pin}') ")
      puts "!!! Employee id #{new_emp_id} Name: #{name} inserted !!!"
    rescue => e
      puts "Insert Failed - Database Error!"
      puts e.message
    end
  end

  #Deleting Employee records
  def delete_employee(delete)
    @client.query("DELETE FROM employees where emp_id = '#{delete}'")
  end

  #Updating Employee records
  def update_employee(column, value, update)
    begin
      @client.query("UPDATE employees SET #{column} = '#{value}' WHERE emp_id = '#{update}'")
    rescue => e
      puts "Update Failed - Database Error"
      puts e.message
    end
  end

  #employee.rb

  def login_employee(emp_id,date,arrival_time)
    begin
      @client.query("INSERT INTO employees_time(emp_id,date,arrival_time) values(#{emp_id},'#{date}','#{arrival_time}')")
    rescue => e
      puts "INSERT UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end


end #end_of_class

require "mysql2"
require "pry"

class Database
  def initialize
    begin
      @client = Mysql2::Client.new(:host => "localhost", :username => "Roman", :password => "Roman123", :database => "employees_reports")
    rescue => e
      puts "CONNECTION UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  #create_table
  def create_table
    begin
      #table - employees
      @client.query("
          CREATE TABLE IF NOT EXISTS employees(
          emp_id INT PRIMARY KEY,
          name VARCHAR(30) NOT NULL, 
          address VARCHAR(30) NOT NULL, 
          email VARCHAR(20) NOT NULL UNIQUE, 
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
      puts "TABLE CREATION UNSUCCESSFUL : DATABASE ERROR"
      puts e.message
    end
  end

  #account_check
  def account_check_employee
    begin
      result_set = @client.query("SELECT * FROM employees")
    rescue => e
      puts "ACCOUNT CHECK UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  #pin_check
  def pin_check_employee(emp_id)
    begin
      pin_set = @client.query("SELECT pin FROM employees_pin where emp_id = '#{emp_id}' ")
    rescue => e
      puts "PIN CHECK UNSUCCESSFUL - DATABASE ERROR"
      e.message
    end
  end

  #listing the employee records
  def list_employee
    begin
      result_set = @client.query("SELECT * FROM employees ORDER BY emp_id")
    rescue => e
      puts "INSERT UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  #listing the employee records
  def list_pin_employee
    begin
      emp_pin_set = @client.query("SELECT * FROM employees_pin ORDER BY emp_id")
    rescue => e
      puts "INSERT UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  #listing the employee records
  def list_time_employee
    begin
      emp_time_set = @client.query("SELECT * FROM employees_time ORDER BY emp_id")
    rescue => e
      puts "LISTING UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  #inserting Employee details in the information
  def insert_employee(new_emp_id, name, address, phone, department, present, pin)
    begin
      @client.query("INSERT INTO employees VALUES('#{new_emp_id}','#{name}','#{address}','#{phone}','#{department}','#{present}') ")
      @client.query("INSERT INTO employees_pin(emp_id,pin)  VALUES('#{new_emp_id}','#{pin}') ")
    rescue => e
      puts "INSERT UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  #Deleting Employee records
  def delete_employee(delete)
    begin
      @client.query("DELETE FROM employees where emp_id = '#{delete}'")
    rescue => exception
      puts "DELETE UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  #Updating Employee records
  def update_employee(column, value, update)
    begin
      @client.query("UPDATE employees SET #{column} = '#{value}' WHERE emp_id = '#{update}'")
    rescue => e
      puts "UPDATE UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  #employee.rb

  def login_employee(emp_id, date, arrival_time)
    begin
      @client.query("INSERT INTO employees_time(emp_id,date,arrival_time) values(#{emp_id},'#{date}','#{arrival_time}')")
    rescue => e
      puts "INSERT UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  def logout_employee(emp_id)
    begin
      @client.query("SELECT arrival_time FROM employees_time where emp_id='#{emp_id}'")
    rescue => exception
      puts "EMPLOYEES LOGOUT UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  def logout_check_employee(emp_id, depart_time)
    begin
      @client.query("UPDATE employees_time SET depart_time ='#{depart_time}' WHERE emp_id = '#{emp_id}'")
      puts "** SUCCESS : Employee id: #{emp_id} | Departure time #{depart_time} ***"
    rescue => e
      puts "EMPLOYEES LOGOUT UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  #closing_connection
  def close_con
    begin
      @client.close_con
    rescue => e
      puts "ERROR : DATABASE CLOSING UNSUCCESSFUL"
      puts e.message
    end
  end
end #end_of_class

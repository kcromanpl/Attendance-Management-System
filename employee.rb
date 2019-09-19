require 'mysql2'
require './database_connect'
require "pry"

class Employee
  
  def initialize(client)
    #initializing database connection
    @client = client 
  end

  def emp_choose(pin,emp_id)
    @pin = pin
    @emp_id = emp_id
  
    puts "Employee Attendance Sheet"
    print "Login(0) / Logout(1) : "; emp_out = gets.chomp.to_i
    case emp_out
    when 0
      login
      run_again
    when 1
      logout
      run_again
    else
      puts "Invalid Selection"
    end
  end
     
  def login
    @emp_time_set = @client.query("SELECT * FROM emp_time")  

    puts "Employee ID: #{@emp_id}";
    print "Enter Time ID: "; time_id = gets.chomp.to_i
   
    date = Date.today
    arrival = Time.now
    arrival_time = arrival.strftime("%Y-%m-%d %H:%M:%S")
    @client.query("INSERT INTO emp_time(time_id,emp_id,date,arrival_time) values(#{time_id},#{@emp_id},'#{date}','#{arrival_time}')")
    #only true if function is executed
    @checkvar = true
  end   
  

end #end_of_class

# e = Employee.new
# e.insert
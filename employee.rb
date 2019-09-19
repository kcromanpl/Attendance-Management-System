require "mysql2"
require "./database_connect"
require "pry"

class Employee
  def initialize(client)
    #initializing database connection
    @client = client
  end

  def emp_choose(pin, emp_id)
    @pin = pin
    @emp_id = emp_id

    puts "Employee Attendance Sheet"
    print "Login(1) / Logout(2) : "; emp_out = gets.chomp.to_i
    case emp_out
    when 1
      login
    when 2
      logout
    else
      puts "Invalid Selection"
      emp_choose(pin, emp_id)
    end
  end

  #login time for employee
  def login
    # @emp_time_set = @client.query("SELECT * FROM employees_time")

    puts "Employee ID: #{@emp_id}"
    date = Date.today
    arrival = Time.now
    arrival_time = arrival.strftime("%Y-%m-%d %H:%M:%S")
    begin
      @client.query("INSERT INTO employees_time(emp_id,date,arrival_time) values(#{@emp_id},'#{date}','#{arrival_time}')")
      puts "** SUCCESS : Employee id: #{@emp_id} | Arrival time #{arrival_time} ***"
    rescue => e
      puts "INSERT UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  #logout section for employee
  def logout
    check_set = @client.query("SELECT arrival_time FROM employees_time where emp_id='#{@emp_id}'")
    # binding.pry
    if (check_set.size != 0)
      date = Date.today
      depart = Time.now
      depart_time = depart.strftime("%Y-%m-%d %H:%M:%S")
      begin
        @client.query("UPDATE employees_time SET depart_time ='#{depart_time}' WHERE emp_id = '#{@emp_id}'")
        puts "** SUCCESS : Employee id: #{@emp_id} | Departure time #{depart_time} ***"
      rescue => e
        puts "INSERT UNSUCCESSFUL - DATABASE ERROR"
        puts e.message
      end
    else
      puts "Login Entry Not Found"
    end
  end
end #end_of_class

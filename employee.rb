require "mysql2"
require "pry"
require "./database_connect"

class Employee
  def initialize(db)
    #initializing database connection
    @client = db
  end

  #choosing employee login or logout
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

  #login section for employee
  def login
    puts "Employee ID: #{@emp_id}"
    date = Date.today
    arrival = Time.now
    arrival_time = arrival.strftime("%Y-%m-%d %H:%M:%S")

    @client.login_employee(@emp_id, date, arrival_time) #database_connect

    puts "** SUCCESS : Employee id: #{@emp_id} | Arrival time #{arrival_time} ***"
  end

  #logout section for employee
  def logout
    check_set = @client.logout_employee(@emp_id)
    # binding.pry
    if (check_set.size != 0)
      date = Date.today
      depart = Time.now
      depart_time = depart.strftime("%Y-%m-%d %H:%M:%S")

      @client.logout_check_employee(@emp_id, depart_time)  #database_connect
    else
      puts "Login Entry Not Found"
    end
  end
end #end_of_class

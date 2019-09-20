require "mysql2"
require "./database_connect"
require "./employee"

class Attendance
  def initialize
    #initializes the Mysql connection
    begin
      @client_method = Database.new
      @empclass = Employee.new(@client_method)
    rescue => e
      puts "CONNECTION UNSUCCESSFUL - DATABASE ERROR"
      puts e.message
    end
  end

  #checks if account is in database
  def account_check
    @result_set = @client_method.account_check_employee   #database_connect
    #array for CRUD operation (update & delete)
    @update_set = Array.new
    @result_set.each do |row|
      @update_set << row["emp_id"]
    end
    puts "\n************************************************************"
    puts "\tWELCOME !!! RUBY ATTENDANCE MANAGEMENT SYSTEM !!!"
    puts "************************************************************\n"
    print("Enter Your Account number: ")
    @emp_id = gets.chomp.to_i
    if (@update_set.include?(@emp_id))
      pin_check
    else
      puts "Account Not Found"
      account_check
    end
  end

  #checks if pin matches the database
  def pin_check
    pin_set = @client_method.pin_check_employee(@emp_id)
    pin_set.each do |i|
      @pin = i["pin"]
    end
    print ("Enter your PIN: ")
    pin_number = gets.chomp.to_i

    #checks for Admin or Employee Account
    if (pin_number == @pin && @emp_id == 1)
      print ("\n !!! ADMIN ACCOUNT - PIN MATCHED !!!\n\n")
      access
    elsif (pin_number == @pin)
      print ("\n!!! EMPLOYEE ACCOUNT - PIN MATCHED !!!\n\n")
      @empclass.emp_choose(@pin, @emp_id) #empolyee.rb
    else
      print ("\nPIN : No Match\n")
      pin_check
    end
  end

  #CRUD oprations for Employee if Account & Pin Matched
  def access
    puts "\t1.List of Employees\n\n\t2. List employees Pin\n\n\t3. List employees Time\n\n\t4. Search for Employee\n\n\t5. Add Employees\n\n\t6. Update Employee Information\n\n\t7. Delete Employee\n\n\t8. Exit\n\n"
    print ("Enter Your Selection (1/2/3/4/5/6/7/8): ")
    action = gets.chomp.to_i
    case action
    when 1
      list
    when 2
      list_pin
    when 3
      list_time
    when 4
      search
    when 5
      insert
    when 6
      update
    when 7
      delete
    when 8
      exit
      @client_method.close_con
    else
      puts "Invalid Selection"
      run_again
    end
  end

  #terminating on user input only
  def run_again
    print "Continue (Y/y)? or Check Account list (A/a) : "
    choice = gets.chomp.downcase
    if (choice == "y")
      access
    elsif (choice == "a")
      list
      sleep(2) #program waits for 2 seconds
      access
    else
      puts "TERMINATED"
      exit
      @client_method.close_con
    end
  end

  #listing the Employee information in the database
  def list
    @result_set = @client_method.list_employee
    puts ("Employee List")
    puts "|Employee ID \t|\t Name \t|\t Address \t|\t Email \t\t\t|\t Department \t| \t Present \t|"
    puts "-----------------------------------------------------------------------------------------------------------------------------------------"
    @result_set.each_with_index do |value, index|
      print "|\t #{value["emp_id"]} \t|\t #{value["name"]} \t|\t #{value["address"]} \t|\t #{value["email"]} \t|\t #{value["department"]} \t|\t #{value["present"]} \t\t|"
      print "\n"
    end
    run_again
  end

  #Searching for certain employee by name
  def search
    print ("Enter Employee name to search: "); search = gets.chomp
    puts ("Employee List with Search value: #{search}")
    flag = 0
    puts "|Employee ID \t|\t Name \t|\t Address \t|\t Email \t\t\t|\t Department \t| \t Present \t|"
    puts "-----------------------------------------------------------------------------------------------------------------------------------------"
    @result_set.each_with_index do |value, index|
      if value["name"].casecmp(search) == 0
        print "|\t #{value["emp_id"]} \t|\t #{value["name"]} \t|\t #{value["address"]} \t|\t #{value["email"]} \t|\t #{value["department"]} \t|\t #{value["present"]} \t\t|"
        print "\n"
        flag += 1
      end
    end
    if flag == 0
      puts "No Employee found with Name: #{search}"
    end
    run_again
  end

  #listing employee_pin from Admin account
  def list_pin
    emp_pin_set = @client_method.list_pin_employee #database_connect
    puts ("Employee Pin List")

    puts "|Employee ID \t|\t Pin \t|"
    puts "---------------------------------"
    emp_pin_set.each_with_index do |value, index|
      print "|\t #{value["emp_id"]} \t|\t #{value["pin"]} \t|"
      print "\n"
    end
    run_again
  end

  #listing employee_pin from Admin account
  def list_time
    emp_time_set = @client_method.list_time_employee #database_connect
    puts ("Employee Time List")

    puts "|\tTime ID|\tEmployee ID|\tDate \t\t|\t\t Arrival Time\t\t|\t\tDepart Time\t\t|"
    puts "----------------------------------------------------------------------------------------------------------------------------------------"
    emp_time_set.each_with_index do |value, index|
      print "|\t #{value["time_id"]} \t|\t #{value["emp_id"]} \t|\t #{value["date"]} \t|\t #{value["arrival_time"]} \t|\t #{value["depart_time"]} \t|"
      print "\n"
    end
    run_again
  end

  #inserting Employee details in the information
  def insert
    valid = 1
    puts "Enter Employee Details"
    print "Enter Employee ID: "; new_emp_id = gets.chomp.to_i
    print "Enter Name: "; name = gets.chomp
    print "Enter Address: "; address = gets.chomp
    print "Enter Email: "; check_email = gets.chomp
    #RegEx pattern matching for mail
    email_pat = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    if (check_email.match?(email_pat))
      email = check_email
    else
      valid = 0
      puts "Warning : Invalid email Address | Please enter valid one"
    end
    print "Enter Department:"; department = gets.chomp
    print "Enter Present: (0/1) "; check_present = gets.chomp.to_i
    #check if input Present is TINYINT
    if (check_present == 0 || check_present == 1)
      present = check_present
    else
      valid = 0
      puts "\nWarning : Present must be either 0(Present) or 1(Absent) | Value maynot be inserted\n\n"
    end
    print "Enter Pin: "; pin = gets.chomp.to_i
    if (valid == 1)
      @client_method.insert_employee(new_emp_id, name, address, email, department, present, pin);  #database_connect
      puts "\nNEW EMPLOYEE ID #{new_emp_id} INSERTED\n"
    else
      puts "Error in data entry, enter valid one"
    end
    run_again
  end

  #Deleting Employee
  def delete
    puts "Deleting Employee Details"
    print "Enter the Employee id,you want to delete: "; delete = gets.chomp.to_i

    if @update_set.include?(delete)
      @client_method.delete_employee(delete)  #database_connect
      puts "Employee '#{delete}' Deleted"
      run_again
    else
      puts "Employee '#{delete}' not found"
      run_again
    end
  end

  #Updating Employee Information
  def update
    puts "Updating Employee Details"
    print "Enter the Employee id,you want to update: "; update = gets.chomp.to_i

    if @update_set.include?(update)
      print "What do You want to update ? : "
      puts "\n\t1.Employee Id\n\n\t2.Employee Name\n\n\t3. Adress\n\n\t4. Email Address\n\n\t5. Department\n\n\t6. Present"
      print ("Enter Your Selection (1/2/3/4/5/6/7/8): ")
      action = gets.chomp.to_i
      case action
      when 1
        column = "emp_id"
      when 2
        column = "name"
      when 3
        column = "address"
      when 4
        column = "email"
      when 5
        column = "department"
      when 6
        column = "present"
      else
        puts "Invalid Selection"
        run_again
      end
      print "Enter the New value : "; value = gets.chomp
      @client_method.update_employee(column, value, update) #database_conect
      puts "Employee '#{update}' Updated"
      run_again
    else
      puts "Employee '#{update}' not found"
      run_again
    end
  end
end #end_of_class

# Database.new
a = Attendance.new
a.account_check

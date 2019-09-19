require "mysql2"
require "./database_connect"
require "./employee"

class Attendance
  def initialize
    #initializes the Mysql connection
    begin
      @client = Database.create_con
      @empclass = Employee.new(@client)
    rescue => e
      puts "Error connecting to database"
      puts e.message
    end
  end

  #checks if account is in database
  def account_check
    begin
      @result_set = @client.query("SELECT * FROM employees")

      #array for CRUD operation (update & delete)
      @update_set = Array.new
      @result_set.each do |row|
        @update_set << row["emp_id"]
      end
    rescue => e
      puts "Account Check Failed - Database Error!"
      puts e.message
    end

    puts "\nWELCOME !!! RUBY ATTENDANCE MANAGEMENT SYSTEM !!!\n"
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
    begin
      @pin_set = @client.query("SELECT pin FROM employees_pin where emp_id = '#{@emp_id}' ")
      @pin_set.each do |i|
        @pin = i["pin"]
      end
    rescue => e
      puts "Pin check failed - Database Error !!"
      e.message
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
    puts "\n1.List of Employees\n\n2. List employees Pin\n\n3. List employees Time\n\n4. Search for Employee\n\n5. Add Employees\n\n6. Update Employee Information\n\n7. Delete Employee\n\n8. Exit"
    print ("Enter Your Selection (1/2/3/4/5/6): ")
    action = gets.chomp.to_i
    case action
    when 1
      list
    when 2
      list_pin
    when 3
      list_employee_time
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
    end
  end

  #listing the Employee information in the database
  def list
    begin
      @result_set = @client.query("SELECT * FROM employees")
    rescue => e
      puts "Listing Failed - Database Error"
      puts e.message
    end
    #array for CRUD operation (update & delete)
    @update_set = Array.new
    @result_set.each do |row|
      @update_set << row["emp_id"]
    end
    puts ("Employee List")
    puts "|Employee ID \t|\t Name \t|\t Address \t|\t Phone \t\t\t|\t Department \t| \t Present \t|"
    puts "-----------------------------------------------------------------------------------------------------------------------------------------"
    @result_set.each_with_index do |value, index|
      print "|\t #{value["emp_id"]} \t|\t #{value["name"]} \t|\t #{value["address"]} \t|\t #{value["phone"]} \t|\t #{value["department"]} \t|\t #{value["present"]} \t\t|"
      print "\n"
    end
    run_again
  end

  #Searching for certain employee by name
  def search
    print ("Enter Employee name to search: "); search = gets.chomp
    puts ("Employee List with Search value: #{search}")
    flag = 0
    puts "|Employee ID \t|\t Name \t|\t Address \t|\t Phone \t\t\t|\t Department \t| \t Present \t|"
    puts "-----------------------------------------------------------------------------------------------------------------------------------------"
    @result_set.each_with_index do |value, index|
      if value["name"].casecmp(search) == 0
        print "|\t #{value["emp_id"]} \t|\t #{value["name"]} \t|\t #{value["address"]} \t|\t #{value["phone"]} \t|\t #{value["department"]} \t|\t #{value["present"]} \t\t|"
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
    begin
      @emp_pin_set = @client.query("SELECT * FROM employees_pin")
    rescue => e
      puts "Listing Failed - Database Error"
      puts e.message
    end
    puts ("Employee Pin List")

    puts "|Employee ID \t|\t Pin \t|"
    puts "---------------------------------"
    @emp_pin_set.each_with_index do |value, index|
      print "|\t #{value["emp_id"]} \t|\t #{value["pin"]} \t|"
      print "\n"
    end
    run_again
  end

  #listing employee_pin from Admin account
  def list_employee_time
    begin
      @emp_pin_set = @client.query("SELECT * FROM employees_time")
    rescue => e
      puts "Listing Failed - Database Error"
      puts e.message
    end
    puts ("Employee Time List")

    puts "|\tTime ID|\tEmployee ID|\tDate \t\t|\t\t Arrival Time\t\t|\t\tDepart Time\t\t|"
    puts "---------------------------------"
    @emp_pin_set.each_with_index do |value, index|
      print "|\t #{value["time_id"]} \t|\t #{value["emp_id"]} \t|\t #{value["date"]} \t|\t #{value["arrival_time"]} \t|\t #{value["depart_time"]} \t|"
      print "\n"
    end
    run_again
  end

  #inserting Employee details in the information
  def insert
    puts "Enter Employee Details"
    print "Enter Employee ID: "; new_emp_id = gets.chomp.to_i
    print "Enter Name "; name = gets.chomp
    print "Enter Address "; address = gets.chomp
    print "Enter Phone "; phone = gets.chomp
    print "Enter Department "; department = gets.chomp
    print "Enter Present (0/1) "; present = gets.chomp.to_i
    print "Enter Pin "; pin = gets.chomp.to_i
    begin
      # binding.pry
      @client.query("INSERT INTO employees VALUES('#{new_emp_id}','#{name}','#{address}','#{phone}','#{department}','#{present}') ")
      @client.query("INSERT INTO employees_pin VALUES(7,'#{new_emp_id}','#{pin}') ")
    rescue => e
      puts "Insert Failed - Database Error!"
      puts e.message
    end
    run_again
  end

  #Deleting Employee
  def delete
    puts "Deleting Employee Details"
    print "Enter the Employee id,you want to delete: "; @delete = gets.chomp.to_i

    if @update_set.include?(@delete)
      @client.query("DELETE FROM employees where emp_id = '#{@delete}'")
      puts "Employee '#{@delete}' Deleted"
      run_again
    else
      puts "Employee '#{@delete}' not found"
      run_again
    end
  end

  #Updating Employee Information
  def update
    puts "Updating Employee Details"
    print "Enter the Employee id,you want to update: "; @update = gets.chomp.to_i

    if @update_set.include?(@update)
      print "What do You want to update ? : "
      puts "\n1.Employee Id\n\n2.Employee Name\n\n3. Adress\n\n4. Phone Number\n\n5. Department\n\n6. Present"
      print ("Enter Your Selection (1/2/3/4/5/6): ")
      action = gets.chomp.to_i
      case action
      when 1
        @column = "emp_id"
      when 2
        @column = "Name"
      when 3
        @column = "Address"
      when 4
        @column = "Phone"
      when 5
        @column = "Department"
      when 6
        @column = "Present"
      else
        puts "Invalid Selection"
        run_again
      end
      print "Enter the New value : "; @value = gets.chomp
      begin
        @client.query("UPDATE employees SET #{@column} = '#{@value}' WHERE emp_id = '#{@update}'")
      rescue => e
        puts "Update Failed - Database Error"
        puts e.message
      end
      puts "Employee '#{@update}' Updated"
      run_again
    else
      puts "Employee '#{@update}' not found"
      run_again
    end
  end
end #end_of_class

Database.new
a = Attendance.new
a.account_check

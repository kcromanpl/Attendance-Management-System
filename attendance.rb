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

  #checks if account is in database
  def account_check
    #array for CRUD operation (update & delete)
    begin
      @result_set = @client.query("SELECT * FROM employees")
      @update_set = Array.new
      @result_set.each do |row|
        @update_set << row["emp_id"]
      end
    rescue => e
      puts "Account Check Failed - Database Error!"
      puts e.message
    end

    puts "\nWELCOME !!! RUBY ATTENDANCE MANAGEMENT SYSTEM !!!"
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
    if (pin_number == @pin && @emp_id == 0)
      print ("\nAdmin Account - PIN Matched\n")
      access
    elsif (pin_number == @pin)
      print ("\nEmployee Account - PIN Matched\n")
      @empclass.emp_choose(@pin, @emp_id)
    else
      print ("\nPIN : No Match\n")
      pin_check
    end
  end

  #CRUD oprations for Employee if Account & Pin Matched
  def access
    puts "\n1.List of Employees\n\n2. Add Employees\n\n3. Update Employee Information\n\n4. Delete Employee\n\n5. Exit"
    print ("Enter Your Selection (1/2/3/4/5): ")
    action = gets.chomp.to_i
    case action
    when 1
      list
    when 2
      insert
    when 3
      update
    when 4
      delete
    when 5
      exit
    else
      puts "Invalid Selection"
      run_again
    end
  end

  #listing the Employee information in the database
  def list
    #array for CRUD operation (update & delete)
    begin
      @result_set = @client.query("SELECT * FROM employees")
    rescue => e
      puts "Listing Failed - Database Error"
      puts e.message
    end
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

  #inserting Employee details in the information
  def insert
    puts "Enter Employee Details"
    print "Enter Employee ID: "; @emp_id = gets.chomp.to_i
    print "Enter Name "; name = gets.chomp
    print "Enter Address "; address = gets.chomp
    print "Enter Phone "; phone = gets.chomp
    print "Enter Department "; department = gets.chomp
    print "Enter Present (0/1) "; present = gets.chomp.to_i
    begin
      @client.query("INSERT INTO employees VALUES('#{@emp_id}','#{name}','#{address}','#{phone}','#{department}','#{present}') ")
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

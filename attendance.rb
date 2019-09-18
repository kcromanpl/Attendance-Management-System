require 'mysql2'
require './database_connect'

class Attendance
  def initialize
  #initializing connection
    @client = Database.new
  end

  #checks if account is in database
  def account_check
    puts "\nWELCOME !!! RUBY ATTENDANCE MANAGEMENT SYSTEM !!!"
    print("Enter Your Account number: ")
    emp_id = gets.chomp.to_i;
    @client.employee_account_check(emp_id)
  end

  #CRUD oprations for Employee if Account & Pin Matched
  def access
    puts "\n1.List of Employees\n\n2. Add Employees\n\n3. Update Employee Information\n\n4. Delete Employee"
    print ("Enter Your Selection (1/2/3/4): ")
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
        else
          puts "Invalid Selection"
          # run_again
      end
  end
  
  #listing the Employee information in the database
  def list
    @client.list_employee
  end
  
  #inserting Employee details in the information
  def insert
    puts "Enter Employee Details"
    print "Enter Employee ID: "; emp_id = gets.chomp.to_i
    print "Enter Name "; name = gets.chomp
    print "Enter Address "; address = gets.chomp
    print "Enter Phone "; phone = gets.chomp
    print "Enter Department "; department = gets.chomp
    print "Enter Present (0/1) "; present = gets.chomp.to_i
    #empty check emp_id.empty?
    @client.insert_employee(emp_id,name,address,phone,department,present);
  end
  
  #Deleting Employee records
  def delete
    puts "Deleting Employee Details"
    print "Enter the Employee id,you want to delete: "; delete = gets.chomp.to_i
    @client.delete_employee(delete) 
  end
  
  #Updating Employee Information
  def update
    puts "Updating Employee Details"
    print "Enter the Employee id,you want to update: "; update = gets.chomp.to_i
    @client.update_employee(update)
  end


end #end_of_class
a = Attendance.new
a.account_check
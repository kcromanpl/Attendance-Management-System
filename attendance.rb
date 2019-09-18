require 'mysql2'
require './database_connect'

class Attendance
  def initialize
    #initializing connection
    @client = Database.new
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


end #end_of_class
a = Attendance.new
a.list
a.insert
a.list


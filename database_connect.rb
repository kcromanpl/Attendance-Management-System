require 'mysql2'
require 'pry'

class Database
  def initialize
   #initializes the Mysql connection 
    begin
      @client =   Mysql2::Client.new(:host => "localhost", :username => "Roman", :password => "Roman123", :database => "employees_reports")
      @client.query("
        CREATE TABLE IF NOT EXISTS employees(
        emp_id INT PRIMARY KEY,
        name VARCHAR(30) NOT NULL, 
        address VARCHAR(30) NOT NULL, 
        phone VARCHAR(20) NOT NULL, 
        department VARCHAR(20) NOT NULL, 
        present TINYINT(1) NOT NULL)
        ")
    rescue => e
      puts "Error connecting to database"
      puts e.message
    end
  end

  #listing the employee records
  def list_employee
    #array for CRUD operation (update & delete)
    @result_set = @client.query("SELECT * FROM employees")

    @update_set = Array.new
    @result_set.each do |row|
      @update_set<<row['emp_id']
    end
    puts ("Employee List")
    
    puts "|Employee ID \t|\t Name \t|\t Address \t|\t Phone \t\t\t|\t Department \t| \t Present \t|"
    puts "-----------------------------------------------------------------------------------------------------------------------------------------"
    @result_set.each_with_index do |value,index|
      print "|\t #{value['emp_id']} \t|\t #{value['name']} \t|\t #{value['address']} \t|\t #{value['phone']} \t|\t #{value['department']} \t|\t #{value['present']} \t\t|"
     print "\n"
    end
    # run_again
  end

  def insert_employee(emp_id,name,address,phone,department,present)
    
    begin
      @client.query("INSERT INTO employees VALUES('#{emp_id}','#{name}','#{address}','#{phone}','#{department}','#{present}') ")
      # run_again
    rescue => e
      puts "Error in Adding Employee!"
      puts e.message
    end
  end

  def delete_employee(delete)

    if @update_set.include?(delete)
      @client.query("DELETE FROM employees where emp_id = '#{delete}'")
      puts "Employee '#{delete}' Deleted"
      # run_again
    else
      puts"Employee '#{delete}' not found"
      # run_again
    end
  end

end #end_of_class
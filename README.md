# Attendance Management System
	Attendance Management System manages the daily arrival and departure time of employees. Attendance System forms the lifeline of the business institute to manage the Employee and the outcome. It comprises with the basics of employee's attendance management system in CLI(Character line Interface). 

## Motivation
	Attendance Management System was developed in order to solve the daily management of employees in projects & companies. It is very useful to test its employee attendance continuously for mutual development of both employee and the company.

## Description

## Technologies used
	Ruby | Mysql2 | pry 

## List of Tables

1. 	Employees
      emp_id 	=> int Primary key,
      Name 		=> varchar(30)
      Address 	=> varchar(30)
      Phone 	=> varchar(20)
      Department => varchar(20)
      Present 	=> TINYINT(1) n

 2. Emps_pin

 	pin_id		=> int Primary Key
 	emp_id 		=> int Foreign Key
 	pin 		=> int(4)

 3. Employees_time

 	time_id		=> int Primary Key
 	Date 		=> Date
 	arrival_time=> TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 	depart_time => TIMESTAMP

## Change Logs
 3.0 rspec initialized

 2.3 emp_choose for choosing login/logout
 2.2 Method logout for registering depart time
 2.1 Method login for registering the arrival time
 2.0 employees.rb - Class employee with login\logout methods for employee 

 1.8 search - searching existing employee records
 1.7 update - Updates Employee records
 1.6 delete - Deletes Employee Records
 1.5 insert - Inserting Employee details
 1.4 list - Listing the accounts in the database
 1.3 access & run_again - Accessing the database if Account & Pin matches.
 Terminates only when user decides to do so.
 1.2 pin_check - checks if pin matches the database
 1.1 account_check - checks if account is in database
 1.0 attendance.rb - Connection Established


 0.2 Created table employees, employees_pin, employees_time 
 0.1 Created Database - 'employees_reports'
 0.0 database_connect.rb - initializes the mysql2 connection


<!-- ## Installation

Download the ruby file -->
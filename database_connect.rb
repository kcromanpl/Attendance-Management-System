require 'mysql2'
require 'pry'


class Database

  def self.create_con
    Mysql2::Client.new(:host => "localhost", :username => "Roman", :password => "Roman123", :database => "employees_reports")
  end
  
end
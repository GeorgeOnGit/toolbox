#! /usr/bin/ruby
require File.expand_path("../../online/config/application.rb", __FILE__ )
Store::Application.initialize!

puts ActiveRecord::Base.connection.current_database

#automatically generate unit test fixture
#by flushing out development db (store_development) to $str/spec/fixtures 
# e.g. fix_fixture 'users', User.all 
module Fixture
class Table
 #
 def initialize table_name
  @table = table_name
 end
 #
 def model 
  @table.singularize.camelize.constantize
 end
 #
 def fix_fixture filename = @table
   spec_fixture_path = File.expand_path("../../store/spec/fixtures", __FILE__ )

   [spec_fixture_path].each do | fixture_path  |
    File.open("#{fixture_path}/#{filename}.yml", 'w') do |f|
      self.model.all.each { |r | 
       s = {r.id => r.attributes}.to_yaml
       s = s.gsub(/--- /, '    ') 
       f.puts s
      }
    end 
   end
 end
 #
end
#
 ActiveRecord::Base.connection.tables.each do | table_name |
  unless ['schema_migrations', 'sessions'].include? table_name
  puts "flushing #{table_name}."
  table = Table.new(table_name)
  table.fix_fixture
  end 
 end
end #end of module


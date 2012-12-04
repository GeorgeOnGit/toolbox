#Usage:
#Save file under Rail_root/lib/tasks
# $mkdir  Rail_root/spec/fixtures
#rake fixfixtures:flush

namespace :fixfixtures do 
  class Table
    def initialize table_name
      @table = table_name
    end
 
    def model 
      @table.singularize.camelize.constantize
    end
 
    def fix_fixture filename = @table
      spec_fixture_path = File.expand_path("../../../spec/fixtures", __FILE__ )

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
 
    def self.fixfix
      ActiveRecord::Base.connection.tables.each do | table_name |
        unless ['schema_migrations', 'sessions'].include? table_name
          puts "flushing #{table_name}."
          Table.new(table_name).fix_fixture
        end 
      end
    end
  end #end of Table Class

  task :flush => :environment do
    Table.fixfix 
  end 
end

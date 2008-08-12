
puts "monkey patching Rails::Initializer"
require 'initializer'
module Rails
  class Initializer
    def initialize_database
      puts "called patched init db"
      if configuration.frameworks.include?(:active_record)
        ActiveRecord::Base.configurations = configuration.database_configuration
        puts ActiveRecord::Base.configurations.inspect
        ActiveRecord::Base.establish_connection
      end
    end
  end
end
puts "monkey patched Rails::Initializer"

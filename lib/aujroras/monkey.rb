
$: << File.dirname( __FILE__ ) + '/../../vendor/gems/activerecord-jdbc-0.8.2/lib'

module Aujroras
  module Lemur
    class Patch
      @@patches = []
      def self.patches
        @@patches
      end
      def initialize(name,&block)
        @@patches << self
        @name = name
        if ( defined?( JRuby ) )
          block.call if block
        end
      end
      def to_s
        @name
      end
    end
  end
end

Aujroras::Lemur::Patch.new("Rails::Initializer.initialize_database") do
  module Rails
    class Initializer
      def initialize_database
        if configuration.frameworks.include?(:active_record)
          ActiveRecord::Base.configurations = jdbcize( configuration.database_configuration )
          ActiveRecord::Base.establish_connection
        end
      end

      def jdbcize(database_configuration)
        jdbc_database_configuration = database_configuration.dup

        jdbc_database_configuration.each do |env,conf|
          case( conf['adapter'] )
            when 'postgresql'
            when 'mysql'
            when 'sqlite3'
              conf['adapter'] = 'jdbc'
              conf['driver'] = 'SQLite.JDBCDriver'
              conf['url'] = "jdbc:sqlite:#{conf['database']}"
          end
        end
      
        jdbc_database_configuration
      end
    end
  end
end


require "#{File.dirname(__FILE__)}/../../migration"

namespace :schema do

  desc "Create ActiveRecord migration with name=<name>"
  task :migration do |task|
    Waves::Layers::ORM.create_migration_for(ActiveRecord)
  end

  desc "Performs ActiveRecord migrations to version=<version>"
  task :migrate => :connect do |task|
    version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
    ActiveRecord::Migrator.migrate(Waves::Layers::ORM.migration_directory, version)
  end

  task :connect do
    Waves.main.database
    ActiveRecord::Base.logger = Logger.new($stdout)
  end

end


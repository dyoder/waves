require "#{File.dirname(__FILE__)}/../../migration"

namespace :schema do

  desc "Create a new Sequel Migration with name=<name>"
  task :migration do |task|
    Waves::Layers::ORM.create_migration_for(Sequel)
  end

  desc "Performs Sequel migrations to version=<version>"
  task :migrate do |task|
    version = ENV['version']; version = version.to_i unless version.nil?
    Sequel::Migrator.apply( Waves.application.database, Waves::Layers::ORM.migration_directory , version )
  end

end

require File.dirname(__FILE__) / ".." / ".." / :migration_helper
include Waves::Orm
namespace :schema do

	desc "Create a new Sequel Migration using ENV['name']."
  task :migration do |task|
	
		source          = Migration.template(:sequel, ENV['template'])
		destination     = Migration.destination(ENV['name'])
		migration_name  = Migration.migration_name(ENV['name'])
		
		context = {:class_name => migration_name.camel_case}
		
		Migration.write_erb(context, source, destination)

	end
	
	desc 'Performs migration from version, to version.'
	task :migrate do |task|
		version = ENV['version']; version = version.to_i unless version.nil? 
		Sequel::Migrator.apply( Waves.application.database, Migration.directory , version )
	end
	
end
  
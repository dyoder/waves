require 'sequel'
namespace :schema do

	desc 'Create a new Sequel Migration using name.'
  task :migration do |task|
	
		version = ( ENV['version'].to_i || 
			Sequel::Migrator.get_current_migration_version( Blog.database ) ) + 1

		name = ENV['name'] || 'migration'
		class_name = name.camel_case

		template = ( ENV['template'] || 'empty' ) + '.rb.erb'
		source = :schema / :migration / :templates / template
		destination = :schema / :migration / "#{'%03d' % version}_#{name}.rb"
		code = Erubis::Eruby.new( File.read( source ) ).result( binding )
		File.write( destination, code )

	end
	
	desc 'Performs migration from version, to version.'
	task :migrate do |task|
		version = ENV['version']; version = version.to_i unless version.nil? 
		Sequel::Migrator.apply( Waves.application.database, :schema / :migration , version )
	end
	
end
  
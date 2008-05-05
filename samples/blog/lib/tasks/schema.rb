require 'sequel'
namespace :schema do

  desc 'Create a new Sequel Migration using name.'
  task :migration do |task|

    version = ( ENV['version'].nil? ?
      Sequel::Migrator.get_current_migration_version( Blog.database ) :
      ENV['version'].to_i  ) + 1

    name = ENV['name'] || 'migration'
    class_name = name.camel_case

    template = ( ENV['template'] || 'empty' ) + '.rb.erb'
    source = :schema / :migrations / :templates / template
    destination = :schema / :migrations / "#{'%03d' % version}_#{name}.rb"
    code = Erubis::Eruby.new( File.read( source ) ).result( binding )
    File.write( destination, code )

  end

  desc 'Performs migration from version, to version.'
  task :migrate do |task|
    version = ENV['version']; version = version.to_i unless version.nil?
    Sequel::Migrator.apply( Waves.application.database, :schema / :migrations , version )
  end

end


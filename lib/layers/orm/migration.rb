module Waves
  module Orm
    module Migration

      # stuff in this file largely lifted from Sequel.  Thanks, bro.

      # Glob pattern
      MIGRATION_FILE_PATTERN = '[0-9][0-9][0-9]_*.rb'.freeze

      # Where Waves keeps its migration files
      def self.directory
        :schema / :migrations
      end

      # Returns any found migration files in the supplied directory.
      def self.migration_files(range = nil)
        pattern = directory / MIGRATION_FILE_PATTERN
        files = Dir[pattern].inject([]) do |m, path|
          m[File.basename(path).to_i] = path
          m
        end
        filtered = range ? files[range] : files
        filtered ? filtered.compact : []
      end

      # Use the supplied version number or determine the next in sequence
      # based on the migration files in the migration directory
      def self.next_migration_version
        version = ENV['version'] || latest_migration_version
        version.to_i + 1
      end

      # Uses the migration files in the migration directory to determine
      # the highest numbered existing migration.
      def self.latest_migration_version
        l = migration_files.las
        l ? File.basename(l).to_i : nil
      end

      # If the user doesn't pass a name, defaults to "migration"
      def self.migration_name(name=nil)
        name || 'migration'
      end

      # Returns the path to the migration template file for the given ORM.
      # <em>orm</em> can be a symbol or string
      def self.template(orm, name=nil)
        file = ( name || 'empty' ) + '.rb.erb'
        source = File.dirname(__FILE__) / orm / :migrations / file
      end

      # Given a migration name, returns the path of the file that would be created.
      def self.destination(name)
        version = next_migration_version
        directory / "#{'%03d' % version}_#{migration_name(name)}.rb"
      end

      # Takes an assigns hash as the Erubis context.  Keys in the hash become
      # instance variable names.
      def self.write_erb(context, source, destination)
        code = Erubis::Eruby.new( File.read( source ) ).evaluate( context )
        puts "Creating #{destination}"
        File.write( destination, code )
      end

    end
  end

end

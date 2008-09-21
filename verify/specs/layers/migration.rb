# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")
require 'layers/orm/migration'

ORM = Waves::Layers::ORM

Dir.chdir("#{File.dirname(__FILE__)}/../../samples/blog") do

  describe "Waves::Layers::ORM migration helpers" do
  
    it "defines a standard migration location" do
      ORM.migration_directory.should == "schema/migrations"
    end
  
    it "supplies a list of all migration files found in the standard location" do
      ORM.migration_files.should == ["schema/migrations/001_initial_schema.rb", "schema/migrations/002_add_comments.rb"]
    end
  
    it "detects the highest-numbered existing migration file" do
      ORM.latest_migration_version.should == 2
    end
  
    it "determines the number of the next migration to be created" do
      ORM.next_migration_version.should == 3
    end
    
    it "generates the path for the next migration with a given name" do
      ORM.migration_destination("blink").should == "schema/migrations/003_blink.rb"
    end
  
  end

end
# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "..", "helpers")
require 'layers/orm/sequel'

module TestApplication
  include AutoCode
  module Configurations
    module Development
      stub!(:database).and_return(:adapter => 'sqlite', :database => 'test.db')
    end
  end
  stub!(:config).and_return(Configurations::Development)
  include Waves::Layers::ORM::Sequel
end

Waves << TestApplication
Waves::Console.load( :mode => :development )
TA = TestApplication

describe "An application module which includes the Sequel ORM layer should" do
  
  before { FileUtils.rm 'test.db' if File.exist? 'test.db' }
  
  after { FileUtils.rm 'test.db' if File.exist? 'test.db' }
  
  it "auto_create models that inherit from Sequel::Model" do
    TA::Models::Default.superclass.should == Sequel::Model
  end
  
  it "set the dataset to use the snake_case of the class name as the table name" do
    TA::Models::Default.dataset.to_table_reference.should == "(SELECT * FROM defaults)"
  end
  
  it "provide accessor for database" do
    TA.should.respond_to :database
  end
  
end

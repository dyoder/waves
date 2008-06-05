# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "..", "helpers")
require 'layers/orm/sequel'

module TestApplication
  include AutoCode
  module Configurations
    class Development
      stub!(:database).and_return(:adapter => 'sqlite', :database => 'test.db')
    end
  end
  stub!(:config).and_return(Configurations::Development)
  include Waves::Layers::ORM::Sequel
end

Waves << TestApplication
# Waves::Console.load( :mode => :development )
TA = TestApplication

describe "An application module which includes the Sequel ORM layer" do
  
  wrap { rm_if_exist 'test.db' }
    
  it "auto_creates models that inherit from Sequel::Model" do
    TA::Models::Default.superclass.should == Sequel::Model
  end
  
  it "sets the dataset to use the snake_case of the class name as the table name" do
    TA::Models::Default.dataset.send(:to_table_reference).should =~ /SELECT.+FROM.+defaults+/
  end
  
  it "provides an accessor for database" do
    TA.should.respond_to :database
  end
  
end

# Waves.instance_variable_set(:@application, nil)
# raise Waves.application.inspect
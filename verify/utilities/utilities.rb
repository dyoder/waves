# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

UTILITIES = "#{File.dirname(__FILE__)}/../../lib/utilities"

require "#{UTILITIES}/module"
require "#{UTILITIES}/inflect"
require "#{UTILITIES}/string"
require "#{UTILITIES}/symbol"
require "#{UTILITIES}/kernel"
require "#{UTILITIES}/object"
require "#{UTILITIES}/integer"
require "#{UTILITIES}/proc"
require "#{UTILITIES}/hash"


describe "Waves::Utilities::Module" do
  
  before do
    module Eenie; module Meenie; module Miney; end; end ; end
  end
  
  it "defines a basename method" do
    Eenie::Meenie.basename.should == "Meenie"
    Eenie::Meenie::Miney.basename.should == "Miney"
  end
  
  it "defines [] for easy access to namespaced constants" do
    Eenie[:Meenie].should == Eenie::Meenie
  end
  
end

describe "Waves::Utilities::Inflect" do
  
end

describe "Waves::Utilities::Symbol" do
  
  it "defines / as syntactic sugar for File.join" do
    ( :lib / :utilities ).should == File.join( "lib", "utilities")
  end
  
end

describe "Waves::Utilities::Hash" do
  
  it "adds a non-destructive method for converting all hash keys to strings" do
    h = { :a => 1, 'b' => 2, 3 => 3}
    h.stringify_keys.should == { 'a' => 1, 'b' => 2, '3' => 3}
    h.should == { :a => 1, 'b' => 2, 3 => 3}
  end
  
  it "adds a destructive method for converting hash keys to symbols" do
    h = { "two" => 2, :three => 3}
    h.symbolize_keys!
    h.should == { :two => 2, :three => 3 }
  end
  
end

describe "Waves::Utilities::String" do
  
  it "defines singular and plural inflection methods" do
    Inflect::English.should.receive(:singular).and_return("still boring")
    Inflect::English.should.receive(:plural).and_return("still boring")
    "boring".singular.plural
  end
  
  it "defines / as syntactic sugar for File.join" do
    ( "lib" / "utilities" ).should == File.join( "lib", "utilities" )
    ( "lib" / :utilities ).should == File.join( "lib", "utilities" )
    ( "lib" / 3 ).should == File.join( "lib", "3" )
  end
  
  it "defines a snake_case method" do
    "MilchCow".snake_case.should == "milch_cow"
    "Milch Cow".snake_case.should == "milch_cow"
    "milchCow".snake_case.should == "milch_cow"
    "StrangeFaceMilchCow".snake_case.should == "strange_face_milch_cow"
  end
  
  it "defines a camel_case method" do
    "siege_engine".camel_case.should == "SiegeEngine"
    "ineffective_siege_engine".camel_case.should == "IneffectiveSiegeEngine"
  end
  
  it "defines a lower_camel_case method" do
    "siege_engine".lower_camel_case.should == "siegeEngine"
    "ineffective_siege_engine".lower_camel_case.should == "ineffectiveSiegeEngine"
  end
  
  it "defines a title_case method" do
    # Yes, we know that this is naive title casing.
    "sing ho! for the life of a bear".title_case.should == "Sing Ho! For The Life Of A Bear"
  end
  
end
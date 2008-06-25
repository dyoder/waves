# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")
require "#{UTILITIES}/inflect"
require "#{UTILITIES}/string"

describe "Waves::Utilities::String" do
  
  it "defines singular and plural inflection methods" do
    Inflect::English.should.receive(:singular).and_return("still boring")
    Inflect::English.should.receive(:plural).and_return("still boring")
    "boring".singular.plural
  end
  
  it "defines / as syntactic sugar for File.join" do
    ( "lib" / "utilities" ).should == File.join( "lib", "utilities")
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
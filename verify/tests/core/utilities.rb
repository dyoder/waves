# require 'test_helper' because RubyMate needs help
%w( rubygems bacon facon ).each { |f| require f }
Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit

UTILITIES = "#{File.dirname(__FILE__)}/../../../lib/ext"

require "#{UTILITIES}/module"
require "#{UTILITIES}/inflect"
require "#{UTILITIES}/string"
require "#{UTILITIES}/symbol"
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
  
  it "defines methods for reaching the root constant" do
    Eenie::Meenie::Miney.rootname.should == "Eenie"
    Eenie::Meenie::Miney.root.should == Eenie
  end
  
  it "defines [] for easy access to namespaced constants" do
    Eenie[:Meenie].should == Eenie::Meenie
  end
    
end

describe "a language extended with Waves::Utilities::Inflect" do
  
  before do
    # Nominative only, of course.
    module Latin
      extend Waves::Inflect::InflectorMethods
      rule 'us', 'i'
      rule 'u', 'ua'
      rule 'x', 'gis'
      
      word 'deus', 'di'
      word 'cultus'
      
      singular_rule 'inuum', 'inua'
      plural_rule 'ix', 'ices'
    end
  end
  
  it "can define general pluralization rules" do
    Latin.plural('servus').should == 'servi'
  end
  
  it "can register two-way exceptions for specific words" do
    Latin.plural('deus').should == 'di'
    Latin.plural('cultus').should == 'cultus'
  end
  
  it "can register rules for singularization exceptions" do
    Latin.singular('cornua').should == 'cornu'
    Latin.singular('continua').should == 'continuum'
  end
  
  it "can register rules for pluralization exceptions" do
    Latin.plural('phoenix').should == 'phoenices'
  end
  
  
end

describe "Waves::Utilities::String" do

  # ** API Change **
  # it "delegates singular and plural inflection methods" do
  #   Waves::Inflect::English.should.receive(:singular).and_return("boring")
  #   Waves::Inflect::English.should.receive(:plural).and_return("still boring")
  #   "boring".singular.plural
  # end
  
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

describe "A monkeypatch to Symbol" do
  
  it "defines / as syntactic sugar for File.join" do
    ( :lib / :utilities ).should == File.join( "lib", "utilities")
  end
  
end


describe "Waves::Utilities::Object" do
  
  before do |variable|
    @foo = [ :a, :b, :c ]
  end
  
  it "defines instance_exec, to allow instance_eval-ing a block with parameters" do
    result = @foo.instance_exec(2)  do |i|
      self[i]
    end
    result.should == :c
    
    result = @foo.instance_exec(0,2) do |*args|
      self.slice(*args)
    end
    result.should == [:a, :b]
  end
  
end

describe "Waves::Utilities::Integer" do
  # pedantic, no?
  1.kilobytes.should == "1,024".to_i
  1.megabytes.should == "1,048,576".to_i
  1.gigabytes.should == "1,073,741,824".to_i
  1.terabytes.should == "1,099,511,627,776".to_i
  1.petabytes.should == "1,125,899,906,842,624".to_i
  1.exabytes.should == "1,152,921,504,606,846,976".to_i
  1.zettabytes.should == "1,180,591,620,717,411,303,424".to_i
  1.yottabytes.should == "1,208,925,819,614,629,174,706,176".to_i
end

describe "Waves::Utilities::Proc" do
  
   it "defines | as syntactic sugar for passing the result of a proc to a lambda" do
     p = Proc.new { "smurf" }
     l = lambda { |data| data.reverse }
     result = p | l
     result.call.should == "frums"
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

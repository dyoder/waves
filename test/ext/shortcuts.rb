require "#{File.dirname(__FILE__)}/../helpers.rb"

describe "Waves::Ext::String" do
  it "defines / as syntactic sugar for File.join" do
    ( "lib" / "utilities" ).should == File.join( "lib", "utilities" )
    ( "lib" / :utilities ).should == File.join( "lib", "utilities" )
    ( "lib" / 3 ).should == File.join( "lib", "3" )
  end
end

describe "A monkeypatch to Symbol" do
  
  it "defines / as syntactic sugar for File.join" do
    ( :lib / :utilities ).should == File.join( "lib", "utilities")
  end
  
end

describe "Waves::Ext::Hash" do
  
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

describe "Waves::Ext::Integer" do

  it "has an absolutely pedantic amount of helpers" do
    1.kilobytes.should == "1_024".to_i
    1.megabytes.should == "1_048_576".to_i
    1.gigabytes.should == "1_073_741_824".to_i
    1.terabytes.should == "1_099_511_627_776".to_i
    1.petabytes.should == "1_125_899_906_842_624".to_i
    1.exabytes.should == "1_152_921_504_606_846_976".to_i
    1.zettabytes.should == "1_180_591_620_717_411_303_424".to_i
    1.yottabytes.should == "1_208_925_819_614_629_174_706_176".to_i
  end

end

describe "Waves::Ext::Module" do
  
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
  
  it "defines a method for obtaining the outermost constant name" do
    Eenie::Meenie::Miney.rootname.should == "Eenie"
  end
  
  it "defines a method for obtaining the outermost constant" do
    Eenie::Meenie::Miney.root.should == Eenie
  end
  
end
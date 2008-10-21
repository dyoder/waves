# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "#accept, #accept_charset, and #accept_language" do
  
  before do
    @request = Waves::Request.new(rack_env("/", 
      'HTTP_ACCEPT' => 'text/xml,application/xhtml+xml;q=0.9, text/plain ;q=0.8,image/png,audio/*;q=0.5,*/foo',
      'HTTP_ACCEPT_CHARSET' => 'ISO-8859-1,utf-8;q=0.7;q=0.7',
      'HTTP_ACCEPT_LANGUAGE' => 'en-us,en;q=0.5'
      ))
      @accept = Waves::Request::Accept.parse(@request.env['HTTP_ACCEPT'])
  end
  
  it "evaluates to an array of entries" do
    entries = ["text/xml", "application/xhtml+xml", "text/plain", "image/png", "audio/*", "*/foo"]
    Waves::Request::Accept.parse(@request.env['HTTP_ACCEPT']).should == entries
    
    charsets = [ "ISO-8859-1", "utf-8" ]
    @request.accept_charset.should == charsets
    
    languages = [ "en-us", "en" ]
    @request.accept_language.should == languages
  end
  
  it "matches using === or =~" do
    (@accept === "text/xml").should == true
    # (@accept =~ /xml/).should == true
    (@accept === "text/bogus").should == false
    
    (@request.accept_charset === "utf-8").should == true
    # (@request.accept_charset =~ /utf/).should == true
    (@request.accept_charset === "utf-16").should == false
    
    (@request.accept_language =~ "en-us").should == true
    # (@request.accept_language =~ /en/ ).should == true
    # (@request.accept_language =~ /ru/ ).should == false
    (@request.accept_language === "en-us").should == true
    (@request.accept_language =~ "ru").should == false
  end
  
  it "handles the * wildcard appropriately" do
    # (@accept === "audio/wav").should == true
    # (@accept === "flip/wav").should == false
    # (@accept === /mork/).should == false
    # (@accept === "bar/foo").should == true
    # (@accept === "bar/baz").should == false
  end
  
end
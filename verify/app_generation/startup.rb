# require 'test_helper' because RubyMate needs help

require File.join(File.dirname(__FILE__) , "helpers")


describe "startup.rb in a generated app, without requiring rubygems" do
  before do
    clobber_test_app(AppPath)
    generate_test_app(AppPath)
  end
  
  after do
    clobber_test_app(AppPath)
  end
  
  it "should fail to find waves framework" do
    Dir.chdir(AppPath) do
      stdin, stdout, stderr = Open3.popen3("ruby startup.rb")
      stderr.gets.should =~ %r{no such file to load -- waves \(LoadError\)}
    end
  end
  
end

describe "startup.rb in an app, without gems, but with WAVES defined" do
  before do
    clobber_test_app(AppPath)
    generate_test_app(AppPath)
  end
  
  after do
    clobber_test_app(AppPath)
  end
  
  it "should find and use waves framework source" do
    set_framework_path(AppPath)
    Dir.chdir(AppPath) do
      stdin, stdout, stderr = Open3.popen3("ruby startup.rb")
      stderr.gets.should == nil
    end
  end
end
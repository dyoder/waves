# require 'test_helper' because RubyMate needs help

require File.join(File.dirname(__FILE__) , "helpers")


describe "startup.rb in a generated app" do
  before do
    clobber_test_app(AppPath)
    generate_test_app(AppPath)
  end

  after do
    clobber_test_app(AppPath)
  end
  
  it "should make the scripts executable" do
    File.executable?(File.join(AppPath, "bin", "waves-console")).should.be.true
  end

  it "should fail to find waves framework, if gem is not available" do
    Dir.chdir(AppPath) do
      stdin, stdout, stderr = Open3.popen3("ruby startup.rb")
      stderr.gets.should =~ %r{no such file to load -- waves \(LoadError\)}
    end
  end

  it "should find and use waves framework source when WAVES is defined" do
    set_framework_path(AppPath)
    Dir.chdir(AppPath) do
      stdin, stdout, stderr = Open3.popen3("ruby startup.rb")
      stderr.gets.should == nil
    end
  end
end

# require 'test_helper' because RubyMate needs help

require File.join(File.dirname(__FILE__) , "helpers")

clobber_test_app(AppPath)
generate_test_app(AppPath)

describe "A generated application" do
  
  it "has executable script files" do
    File.executable?(File.join(AppPath, "bin", "waves-console")).should.be.true
  end

  it "will fail to find waves framework, if the gem is not available" do
    Dir.chdir(AppPath) do
      stdin, stdout, stderr = Open3.popen3("ruby startup.rb")
      stderr.gets.should =~ %r{no such file to load -- waves \(LoadError\)}
    end
  end

  it "will find and use waves framework source when WAVES is defined" do
    set_framework_path(AppPath)
    Dir.chdir(AppPath) do
      stdin, stdout, stderr = Open3.popen3("ruby startup.rb")
      stderr.gets.should == nil
    end
  end
  
  it "has the directories we expect it to have" do
    dirs = %w{  bin/ configurations/ controllers/ doc/ helpers/ lib/ 
                log/ models/ public/ schema/ templates/ tmp/ views/ }
    Dir.chdir(AppPath) do
      Dir.glob("*/").should == dirs
    end
  end
  
end

clobber_test_app(AppPath)

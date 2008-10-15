# require 'test_helper' because RubyMate needs help
require "#{File.dirname(__FILE__)}/helpers")

clear_all_apps
module SimpleApplication ; include Waves::Foundations::Compact ; end

describe "An application module which includes the Simple foundation" do

  it "should have basic submodules defined" do
    lambda do
      SimpleApplication::Configurations::Development
      SimpleApplication::Resources::Map
    end.should.not.raise
  end

end

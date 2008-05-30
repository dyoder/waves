# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "helpers")

specification "A developer can register exception handlers" do

  before do
    mapping.clear
    mapping.handle(Waves::Dispatchers::NotFoundError) do
       response.status = 404; response.body = "404 Not Found"
    end
    mapping.handle(Waves::Dispatchers::NotFoundError) do
      response.status = 404; response.body = "Something Different"
    end
  end

  specify 'The minimal 404 handler in SimpleErrors' do

    r = get('/')
    r.status.should == 404
    r.body.should == '404 Not Found'
  end


end

# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "A Waves controller" do
    
  before do
    Waves.application.stub!(:models).and_return(VerifyControllers::Models)
    @request = mock('request')
    @dc = VerifyControllers::Controllers::Default.new(@request)
  end
  
  it "initializes with and can access a request" do
    @dc.request.should == @request
  end
  
  it "can access a destructured version of the request params" do
    request_hash =      { 'beer.name' => 'Pale Rye Ale', 
                          'beer.brew.kind' => 'mini-mash', 
                          'beer.brew.yeast' => 'White Labs British Ale' }
    destructured_hash = { :beer =>  
                            { :name => 'Pale Rye Ale', 
                              :brew => { :kind => 'mini-mash', :yeast => 'White Labs British Ale'}}}
                              
    # @request.should.receive(:params).and_return(request_hash)
    # @dc.params.should == destructured_hash
  end

  
  it "has reflective model helpers to allow generalizing" do
    # Waves.application handwaving done in ./helpers
    
    @dc.model_name.should == 'default'
    @dc.model.should == VerifyControllers::Models::Default
  end  
  
end

describe "The process method of a Waves controller class" do
  
  it "executes a block within the scope of a controller instance" do
    @request = mock('request')
    result = VerifyControllers::Controllers::Default.process(@request) do
      self.class.name
    end
    result.should == "VerifyControllers::Controllers::Default"
  end
  
end
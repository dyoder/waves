# # require 'test_helper' because RubyMate needs help
# require File.join(File.dirname(__FILE__) , "helpers")
# 
# # Nota bene, y'all:  These model helper methods are very ORM specific, and should probably 
# # get moved into the ORM layers.
# 
# describe "The base Waves controller" do
#   
#   before do
#     Waves.application.stub!(:models).and_return(VerifyControllers::Models)
#     @request = mock('request')
#     @dc = VerifyControllers::Controllers::Default.new(@request)
#   end
#   
#   it "can isolate its model's attributes from the request params" do
#     @dc.should.receive(:params).and_return({:foo => 'bar', :default => {:one => 'one', :two => 'two'}})
#     @dc.attributes.should == {:one => 'one', :two => 'two'}
#   end
#   
#   it "provides shortcut methods for common model interactions" do
#     VerifyControllers::Models::Default.should.receive(:all)
#     @dc.all
#     
#     VerifyControllers::Models::Default.should.receive(:[]).with(:name => 'This').and_return('That')
#     @dc.find('This').should == 'That'
#     
#     VerifyControllers::Models::Default.should.receive(:create).with("Does it work?").and_return('It worked!')
#     @dc.should.receive(:attributes).and_return("Does it work?")
#     @dc.create.should == 'It worked!'
#     
#     # @dc.update('This')
#     
#     # @dc.delete('This')
#     
#   end
#   
# end
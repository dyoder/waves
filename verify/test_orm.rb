require File.join(File.dirname(__FILE__), 'helper.rb')

context "A Waves application using the default ORM" do
  
  specify "should provide an accessor for the ORM database connection" do
    TestApp.database.should.be.a.kind_of Sequel::Database
  end

  specify "should autocreate models using the ORM's model class" do
    TestApp::Models::Thing.superclass.should == Sequel::Model
  end
  
end
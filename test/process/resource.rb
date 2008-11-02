require 'test/helpers.rb'
require 'foundations/compact'

describe "Application Context" do
  before do 
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end
  
  after do
    Waves.applications.clear
    Object.instance_eval { remove_const( :Test ) if const_defined?( :Test ) }
  end
  
  feature "Provide acccess to request, response, and session objects" do
    Test::Resources::Map.new( Waves::Request.new( env('/', :method => 'GET' ) ) ).
      instance_eval do
        { :request => Waves::Request, :response => Waves::Response, 
          :session => Waves::Session, :query => Waves::Request::Query }.
          each { |k,v| send( k ).class.should == v }
      end
  end
  
  feature "Shortcuts to the path, url, domain, and session" do
    Test::Resources::Map.new( Waves::Request.new( 
      env('http://localhost/foo/bar.js', :method => 'GET' ) ) ).
      instance_eval do
        { :url => request.url, :path => request.path, 
          :domain => request.domain, :session => request.session }.
          each { |k,v| send( k ).should == v }    
      end
  end

  feature "Access to path and associated helpers" do
    Test::Resources::Map.new( Waves::Request.new( 
      env('http://localhost/foo/bar.js', :method => 'GET' ) ) ).
      instance_eval do
        { :url => 'http://localhost/foo/bar.js', :path => '/foo/bar.js', 
          :basename => '/foo/bar', :extension => 'js' }.
          each { |k,v| send( k ).should == v }
      end
  end

  feature "Access to the application object and name" do
    Test::Resources::Map.new( Waves::Request.new( 
      env('http://localhost/foo/bar.js', :method => 'GET' ) ) ).
      instance_eval do
        { :app => Test, :app_name => :test }.
          each { |k,v| send( k ).should == v }    
      end
  end
  
end

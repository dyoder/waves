# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")

describe "A developer can map requests to filters." do

  before do
    mapping.clear
    handle(Waves::Dispatchers::NotFoundError) { response.status = 404}
    mapping.before( :path => '/filters', :method => :post ) { request.response.write('Before post:') }
    mapping.before( :path => '/filters' ) { request.response.write('Before:') }
    mapping.wrap( :path => '/filters', :method => :post ) { request.response.write(':Wrap post:') }
    mapping.wrap( :path => '/filters' ) { request.response.write(':Wrap:') }
    mapping.path( '/filters' ) { 'During' }
    mapping.after( :path => '/filters', :method => :post ) { request.response.write('After post:') }
    mapping.after( :path => '/filters' ) { request.response.write(':After') }

    regexp = %r{^/filters/(\w+)$}

    mapping.before( :path => regexp ) { |filtername| request.response.write("Before #{filtername}:") }
    mapping.wrap( :path => regexp ) { |filtername| request.response.write(":Wrap #{filtername}:") }
    mapping.path( regexp ) { 'During' }
    mapping.after( :path => regexp ) { |filtername| request.response.write(":After #{filtername}") }

    mapping.before( :path => 'filters_with_no_map' ) { request.response.write("Before") }
    mapping.wrap( :path => 'filters_with_no_map' ) { request.response.write("Wrap") }
    mapping.after( :path => 'filters_with_no_map' ) { request.response.write("After") }

    mapping.before('/pathstring') { request.response.write("Before pathstring") }
    mapping.wrap('/pathstring') { request.response.write("Wrap pathstring") }
    mapping.map('/pathstring') { "During pathstring" }
    mapping.after('/pathstring') { request.response.write("After pathstring") }

    mapping.before(%r{^/pathregexp$}) { request.response.write("Before pathregexp") }
    mapping.wrap(%r{^/pathregexp$}) { request.response.write("Wrap pathregexp") }
    mapping.map(%r{^/pathregexp$}) { "During pathregexp" }
    mapping.after(%r{^/pathregexp$}) { request.response.write("After pathregexp") }

    mapping.before('/pathstring/name', :method => :post) { request.response.write("Before pathstring post") }
    mapping.wrap('/pathstring/name', :method => :post) { request.response.write("Wrap pathstring post") }
    mapping.map('/pathstring/name', :method => :post) { "During pathstring post" }
    mapping.after('/pathstring/name', :method => :post) { request.response.write("After pathstring post") }

    mapping.before(%r{^/pathregexp/name$}, :method => :post) { request.response.write("Before pathregexp post") }
    mapping.wrap(%r{^/pathregexp/name$}, :method => :post) { request.response.write("Wrap pathregexp post") }
    mapping.map(%r{^/pathregexp/name$}, :method => :post) { "During pathregexp post" }
    mapping.after(%r{^/pathregexp/name$}, :method => :post) { request.response.write("After pathregexp post") }
  end

  it "Map a path to a 'before', 'after' and 'wrap' filters." do
    get('/filters').body.should == 'Before::Wrap:During:Wrap::After'
  end

  it "Map a POST to a path to a 'before', 'after' and 'wrap' filters" do
    post('/filters').body.should == 'Before post:Before::Wrap post::Wrap:During:Wrap post::Wrap:After post::After'
  end

  it "The 'before', 'after' and 'wrap' filters accept a regular expression and can extract parameters from the request path" do
    get('/filters/xyz').body.should == 'Before xyz::Wrap xyz:During:Wrap xyz::After xyz'
  end

  it "When having 'before', 'after' and 'wrap' filters but no corresponding map action this results in a 404" do
    get('/filters_with_no_map').status.should == 404
  end

end

module Test
  
  module Configurations
    
    module Mapping
      
      extend Waves::Mapping
      
      path('/', :method => :post ) { 'This is a simple post rule.' }
      path('/') { 'This is a simple get rule.' }
      path('/foo') { "The server says, 'bar!'" }
      
      path %r{/param/(\w+)} do |value|
        "You asked for: #{value}."
      end
      
      url %r{http://localhost:(\d+)/port} do |port|
        port
      end
      
      before( :path => '/filters', :method => :post ) { request.response.write('Before post:') }
      before( :path => '/filters' ) { request.response.write('Before:') }
      wrap( :path => '/filters', :method => :post ) { request.response.write(':Wrap post:') }
      wrap( :path => '/filters' ) { request.response.write(':Wrap:') }
      path( '/filters' ) { 'During' }
      after( :path => '/filters', :method => :post ) { request.response.write('After post:') }
      after( :path => '/filters' ) { request.response.write(':After') }
                       
      regexp = %r{^/filters/(\w+)$}
      before( :path => regexp ) { |filtername| request.response.write("Before #{filtername}:") }
      wrap( :path => regexp ) { |filtername| request.response.write(":Wrap #{filtername}:") }
      path( regexp ) { 'During' }
      after( :path => regexp ) { |filtername| request.response.write(":After #{filtername}") }

      before( :path => 'filters_with_no_map' ) { request.response.write("Before") }
      wrap( :path => 'filters_with_no_map' ) { request.response.write("Wrap") }
      after( :path => 'filters_with_no_map' ) { request.response.write("After") }
      
    end

  end

end
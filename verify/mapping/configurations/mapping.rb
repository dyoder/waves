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
      
      # url %r{localhost:(\d+)/port} do |port|
      #  port
      # end
      

      before( :path => '/filters' ) { request.response.write('Before') }
      path( '/filters' ) { '- During -' }
      after( :path => '/filters' ) { request.response.write('After') }
      
    end

  end

end
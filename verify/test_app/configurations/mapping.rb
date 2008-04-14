module TestApp
  
  module Configurations
    
    module Mapping
      extend Waves::Mapping
      path('/', :method => :post ) { 'This is a simple post rule.' }
      path('/', :method => :put ) { 'This is a simple put rule.' }
      path('/', :method => :delete ) { 'This is a simple delete rule.' }
      path('/', :method => :get) { 'This is a simple get rule.' }
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
      
      before('/pathstring') { request.response.write("Before pathstring") }
      wrap('/pathstring') { request.response.write("Wrap pathstring") }
      map('/pathstring') { "During pathstring" }
      after('/pathstring') { request.response.write("After pathstring") }
      
      before(%r{^/pathregexp$}) { request.response.write("Before pathregexp") }
      wrap(%r{^/pathregexp$}) { request.response.write("Wrap pathregexp") }
      map(%r{^/pathregexp$}) { "During pathregexp" }
      after(%r{^/pathregexp$}) { request.response.write("After pathregexp") }
      
      before('/pathstring/name', :method => :post) { request.response.write("Before pathstring post") }
      wrap('/pathstring/name', :method => :post) { request.response.write("Wrap pathstring post") }
      map('/pathstring/name', :method => :post) { "During pathstring post" }
      after('/pathstring/name', :method => :post) { request.response.write("After pathstring post") }
      
      before(%r{^/pathregexp/name$}, :method => :post) { request.response.write("Before pathregexp post") }
      wrap(%r{^/pathregexp/name$}, :method => :post) { request.response.write("Wrap pathregexp post") }
      map(%r{^/pathregexp/name$}, :method => :post) { "During pathregexp post" }
      after(%r{^/pathregexp/name$}, :method => :post) { request.response.write("After pathregexp post") }
    end

  end

end
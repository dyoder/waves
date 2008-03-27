%w{ rubygems net/http }.each { |dep| require dep }

module Test
  module Spec
    class TestCase
      module InstanceMethods
        def get(path)
          Net::HTTP.start( 'localhost', 3000 ) { |h| h.get(path) }
        end

        def post(path,params={})
          Net::HTTP.start( 'localhost', 3000 ) { |h| h.post(path,params) }
        end

        def put(path,params={})
          Net::HTTP.start( 'localhost', 3000 ) { |h| h.put(path,params) }
        end

        def delete(path,params={})
          Net::HTTP.start( 'localhost', 3000 ) { |h| h.delete(path,params) }
        end
      end
    end
  end
end


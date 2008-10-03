require 'rubygems'; %w{ bacon facon }.each { |dep| require dep }

# Framework lib goes to the front of the loadpath
$:.unshift( File.join(File.dirname(__FILE__), "..", "lib") )
require 'waves'

# Fire up the Bench runtime
Waves::Bench.load

Bacon.extend Bacon::TestUnitOutput
# Bacon.extend Bacon::SpecDoxOutput
# Bacon.extend Bacon::TapOutput
Bacon.summary_on_exit

module Waves
  module Verify
    module Helpers
      
      def feature(desc, &block)
        it(desc, &block) if defined?(VERIFY_FEATURES)
      end
      
      def bug(desc, &block)
        it(desc, &block) if defined?(VERIFY_BUGS)
      end
      
      def ugly(why)
        if defined?(VERIFY_UGLY)
          warn "\n#{why} in:"
          warn Kernel.caller(2).join("\n") 
        end
      end
      
      # def wrap(&block)
      #   @before << block
      #   @after << block
      # end
            
      def clear_all_apps
        Waves.instance_variable_set(:@applications, nil)
      end

      def rm_if_exist(name)
        FileUtils.rm name if File.exist? name
      end
      
      # generate a mock Rack request against the default dispatcher.
      # this must change if we ever do different dispatchers
      def mock_request
        ugly "Hard-coded use of Waves::Dispatchers::Default"
        @request ||= ::Rack::MockRequest.new( ::Waves::Dispatchers::Default.new )
      end

      def waves_request( *args )
        Waves::Request.new( Rack::MockRequest.env_for(*args) )
      end

      def env_for( uri="/", options={} )
        Rack::MockRequest.env_for(uri,options)
      end

      
      # example rack environment
      def rack_env
        {
          'REMOTE_ADDR' => '127.0.0.1',
          'REMOTE_HOST' => 'localhost',
          'SERVER_NAME' => 'localhost',
          'SERVER_PORT' => '3000',
          'SERVER_PORT_SECURE' => '0',
          'SERVER_PROTOCOL' => 'HTTP/1.1',
          'SERVER_SOFTWARE' => 'Waves 1.0',
          'HTTP_HOST' => 'localhost',
          'HTTP_VERSION' => 'HTTP/1.1',
          'HTTP_USER_AGENT' => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14',
          'HTTP_CACHE_CONTROL' => 'max-age=0',
          'HTTP_ACCEPT' => 'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5',
          'HTTP_ACCEPT_LANGUAGE' => 'en-us,en;q=0.5',
          'HTTP_ACCEPT_CHARSET' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
          'HTTP_ACCEPT_ENCODING' => 'gzip,compress;q=0.5,*;q=0.0,',
          'HTTP_CONNECTION' => 'keep-alive',
          'HTTP_KEEP_ALIVE' => '300',
          'HTTP_REFERER' => 'http://localhost/',
          'GATEWAY_INTERFACE' => 'CGI/1.1'
        }
      end
      
    end
  end
end

extend Waves::Verify::Helpers

Bacon::Context.module_eval do
  include Waves::Verify::Helpers

  # some people like to use "specify" instead of "it"
  alias_method :specify, :it
end




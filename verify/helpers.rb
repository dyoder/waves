require 'rubygems'
%w( bacon facon ).each { |f| require f }

# Prepend the framework lib to the loadpath
$:.unshift( File.join(File.dirname(__FILE__), "..", "lib") )
require 'waves'

Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit



module Waves
  module Verify
    module Helpers
      
      def ugly_warning(why)
        if defined?(FIND_UGLY)
          warn "\n#{why} in:"
          warn Kernel.caller(2).join("\n") 
        end
      end
      
      def clear_all_apps
        Waves.instance_variable_set(:@applications, nil)
      end
      
      # Stubs the configuration, to allow waves_request to work
      # One reason this is needed is that a Waves::Request's session uses
      # the current configuration to determine the file store directory and
      # the session expiration time.
      def fake_out_runtime
        ugly_warning "Faking out runtime"
        runtime = mock( "runtime")
        runtime.stub!(:config).and_return( Waves.main[:configurations][:development] )
        Waves::Runtime.stub!(:instance).and_return(runtime)
      end

      def mappings(&block)
        m = ::Waves::Runtime.instance.mapping
        if block
          m.instance_eval(&block)
        end
        m
      end
      
      # mapping helper methods (of dubious utility?)
      %w{ path url always handle threaded generator}.each do |method|
        module_eval "def #{method}(*args,&block); mappings.#{method}(*args,&block);end"
      end
      
      # generate a mock Rack request against the default dispatcher.
      # this must change if we ever do different dispatchers
      def mock_request
        ugly_warning "Hard-coded use of Waves::Dispatchers::Default"
        @request ||= ::Rack::MockRequest.new( ::Waves::Dispatchers::Default.new )
      end

      def waves_request
        Waves::Request.new(Rack::MockRequest.env_for("/"))
      end

      def env_for(uri="/", options={})
        Rack::MockRequest.env_for(uri,options)
      end

      def get(uri, opts={})    mock_request.get(uri, opts)    end
      def post(uri, opts={})   mock_request.post(uri, opts)   end
      def put(uri, opts={})    mock_request.put(uri, opts)    end
      def delete(uri, opts={}) mock_request.delete(uri, opts) end

      def wrap(&block)
        @before << block
        @after << block
      end

      def rm_if_exist(name)
        FileUtils.rm name if File.exist? name
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

module Kernel
  private
  # some people like to use "specification" instead of "describe"
  def specification(name, &block)  Bacon::Context.new(name, &block) end
end



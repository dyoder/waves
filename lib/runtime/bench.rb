module Waves

  class Bench
    
    def self.runtime
      @runtime
    end

    def self.load( options={} )
      @runtime ||= self.new( options )
    end
    
    # Create a new Waves runtime instance.
    def initialize( options={} )
      @options = options
      Dir.chdir options[:directory] if options[:directory]
      Waves::Runtime.instance = self
    end
    
    def config
      @config ||= if ( mode = @options[ :mode ] )
        Waves.main::Configurations[ mode ]
      else
        Class.new { include Attributes }.new( {
          :session => { :duration => 30.minutes, :path => '/tmp/sessions' },
          :mime_types => Waves::MimeTypes,
          :log => { :level => :info, :output => $stderr }
        })
      end

    end
    
    # Provides access to the server mutex for thread-safe operation.
    def synchronize( &block ) ; ( @mutex ||= Mutex.new ).synchronize( &block ) ; end
    def synchronize? ; !options[ :turbo ] ; end

  end

end
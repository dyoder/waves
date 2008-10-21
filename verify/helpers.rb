require 'rubygems'; %w{ bacon facon }.each { |dep| require dep }

# Framework lib goes to the front of the loadpath
$:.unshift( File.join(File.dirname(__FILE__), "..", "lib") )
require 'waves'
require 'runtime/bench'

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
      
      def clear_all_apps
        Waves.instance_variable_set(:@applications, nil)
      end

      def rm_if_exist(name)
        FileUtils.rm name if File.exist? name
      end
      
    end
  end
end

Bacon::Context.module_eval do

  # some people like to use "specify" instead of "it"
  alias_method :specify, :it
end




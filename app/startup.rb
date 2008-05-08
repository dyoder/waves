unless defined?(WAVES)
  WAVES = ENV['WAVES']
end

lambda {
  waves = ( WAVES || File.join(File.dirname(__FILE__), 'waves') )
  $:.unshift(File.join( waves, "lib" )) if File.exist? waves
}.call
require 'waves'
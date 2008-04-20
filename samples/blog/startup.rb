lambda {
  waves = ( ENV['WAVES'] || File.join(File.dirname(__FILE__), 'waves') )
  $:.unshift(File.join( waves, "lib" )) if File.exist? waves
}.call
require 'waves'
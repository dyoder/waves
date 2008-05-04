WAVES ||= ( ENV['WAVES'] || File.join( File.dirname(__FILE__), 'waves') )
$:.unshift( File.join(WAVES, "lib") ) if File.exist? WAVES
require 'waves'
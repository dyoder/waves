unless defined? WAVES
  WAVES = File.join(File.dirname(__FILE__), 'waves')
end

$:.unshift(File.join(WAVES, "lib")) if File.exist? WAVES

require 'waves'
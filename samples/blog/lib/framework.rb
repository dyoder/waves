# Define WAVES_SRC when you want your app to use something
# other than the installed gem of Waves. Examples of common
# cases helpfully provided below
#
# Framework source lives in the same directory as this application
# WAVES_SRC = File.join(File.dirname(__FILE__), '..', '..', 'waves')

# Waves source frozen at my_app/waves will always be used
FROZEN_WAVES = File.join(File.dirname(__FILE__), '..', 'waves')

if USE_FROZEN_WAVES = File.exist?(File.join(FROZEN_WAVES, "lib"))
  $:.unshift(File.join(FROZEN_WAVES, "lib"))
elsif USE_WAVES_SRC = defined?(WAVES_SRC)
  $:.unshift(File.join(WAVES_SRC, "lib"))
end

require 'waves'

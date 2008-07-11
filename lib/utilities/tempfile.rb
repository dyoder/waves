# Patch Ruby's Tempfile class to work around a problem uploading files with Rack.
# 
# The fix came from here: http://sinatra.lighthouseapp.com/projects/9779/tickets/1
# 
# This is fixed in Rack already, but it hasn't made it into a gem.
class Tempfile
  # Make == act like eql?
  def ==(other) ; eql?(other) || super ; end
end
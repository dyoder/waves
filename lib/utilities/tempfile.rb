class Tempfile
  # override method to prevent problem uploading files with Rack
  def ==(other) ; eql?(other) || super ; end
end
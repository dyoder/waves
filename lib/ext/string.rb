# Utility methods mixed into String.
    
class String
  
  # Syntactic sugar for using File.join to concatenate the argument to the receiver.
  #
  #   require "lib" / "utilities" / "string"
  #
  # The idea is not original, but we can't remember where we first saw it.
  # Waves::Ext::Symbol defines the same method, allowing for :files / 'afilename.txt'
  #
  
  def / ( s ) ; File.join( self, s.to_s ); end
  
  alias_method :lower_camel_case, :subcamelcase
  alias_method :camel_case, :camelcase
  alias_method :snake_case, :snakecase
  alias_method :title_case, :titlecase

end
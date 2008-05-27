# Waves extends String with a variety of methods for changing from singular to plural and back, and switching to different types of case and word separators. These methods are similar to those found in Rails and other frameworks, but some (all?) of the names are different. The names here were chosen for increased clarity and are hopefully easy to adjust to ...

class String

  # Does a File.join on the two arguments joined by the /. Very handy
  # for doing platform-safe paths without having to use File.join.
  #
  # I unfortunately don't recall where i first saw this ... see
  # Symbol extension as well, allowing for :files / 'afilename.txt'

  def / ( string )
    File.join(self,string.to_s)
  end

  def singular
    Inflect::English.singular(self)
  end

  alias_method(:singularize, :singular)

  def plural
    Inflect::English.plural(self)
  end

  alias_method(:pluralize, :plural)

  def lower_camel_case
    gsub(/(_)(\w)/) { $2.upcase }
  end

  def camel_case
    lower_camel_case.gsub(/^([a-z])/) { $1.upcase }
  end

  def snake_case
    gsub(/\s+/,'').gsub(/([a-z\d])([A-Z])/){ "#{$1}_#{$2}"}.tr("-", "_").downcase
  end

  def title_case
    gsub(/(^|\s)\s*([a-z])/) { $1 + $2.upcase }
  end

  def text
    gsub(/[\_\-\.\:]/,' ')
  end

end

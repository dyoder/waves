class Symbol
  # Does File.join on self and string, converting self to string before invocation.
  # See String#/ for more.  
  #
  # Note:  This overrides any definitions done politely in modules, such as
  # {Sequel::SQL::ComplexExpressionMethods}[http://sequel.rubyforge.org/classes/Sequel/SQL/ComplexExpressionMethods.html]
  def / ( string )
    self.to_s / string
  end
end

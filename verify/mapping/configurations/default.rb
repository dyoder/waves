module Test
  module Configurations
    class Default < Waves::Configurations::Default
      database :host => 'localhost', :adapter => 'mysql', :database => 'test',
        :user => 'root', :password => ''
    end
  end
end

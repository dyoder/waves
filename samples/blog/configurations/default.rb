module Blog
  module Configurations
    class Default < Waves::Configurations::Defaul
      database :host => host, :adapter => 'sqlite', :database => 'blog',
        :user => 'root', :password => ''
    end
  end
end

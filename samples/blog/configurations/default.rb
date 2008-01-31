module Blog
  module Configurations
    class Default < Waves::Configurations::Default
      database :host => host, :adapter => 'mysql', :database => 'blog',
        :user => 'root', :password => ''
    end
  end
end

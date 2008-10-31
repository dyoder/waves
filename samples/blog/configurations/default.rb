module Blog
  module Configurations
    class Default < Waves::Configurations::Default
      
      resource Blog::Resources::Map
      database :adapter => 'sqlite', :database => 'blog.db'
      server Waves::Servers::Mongrel
      
    end
  end
end
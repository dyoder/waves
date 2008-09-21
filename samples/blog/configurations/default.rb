module Blog
  module Configurations
    class Default < Waves::Configurations::Default
      
      resource Blog::Resources::Map

    end
  end
end
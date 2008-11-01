module Blog
  module Resources
    class Map < Waves::Resources::Base
      
      on( true ) { to( :entry ) }
      
    end
  end
end

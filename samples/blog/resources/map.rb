module Blog
  module Resources
    class Map
      include Waves::Resources::Mixin
      
      on( :get, [] ) { "This be root." }
      
      on( :get, [ /entry|entries/ ] ) { to(:entry) }
      on( true, [ /entry|entries/, true ] ) { to(:entry) }
      
    end
  end
end
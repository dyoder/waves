module Blog
  module Resources
    class Map
      include Waves::Resources::Mixin
      
      on( :get, [] ) { to( :entry ) }
      on( true, [ /entr(y|ies)/, 0..-1 ] ) { to( :entry ) }
      
    end
  end
end
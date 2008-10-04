module Blog
  module Resources
    class Map
      include Waves::Resources::Mixin
      
      on( :get, [] ) { "This be root." }
      
      on( :get, [ /entry|entries/ ] ) { to(:entry) }
      on( true, [ /entry|entries/, true ] ) { to(:entry) }
      
      
      # 
      # # default to story if nothing else matches
      # on( true ) { to( :story ) }
      # 
      # # special URL just for login and authenticating
      # on( [ :get, :post ], [ 'login' ] ) { to( :site ) }
      # 
      # # otherwise assume we are matching against a resource
      # on( true, [ :resource ] ) { to( captured.resource ) }
      # on( true, [ :resource, { :rest => true } ] ) { to( captured.resource ) }
      # 
      # # before anything else, check the accepts headers and route accordingly
      # on( :get, true, :accept => :image ) { to( :image ) }
      # on( :get, true, :accept => [ :css, :javascript ] ) { to( :media ) }
      # on( :get, true, :accept => :rss ) { to( :blog ) }
      
    end
  end
end
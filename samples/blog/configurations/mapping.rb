module Blog

  module Configurations

    module Mapping
      
      extend Waves::Mapping
      
      # specific to comments - on create redirect to the entry, not the comment itself
      path :create, :resource => :comment, :post => [ '/comments' ] do
        redirect( Blog::Resources::Entries.paths.read( action( :create ).entry.name ) )
      end
      
      # defaults for generic resources
      path( :list, :get => [ :resources ] ) { action( :all ) and render( :list ) }
      path( :create, :post => [ :resources ] ) { redirect( paths.read( action( :create ).name, 'edit' ) ) }
      path( :read, :get => [ :resource, :name, { :mode => 'show' } ] ) { action( :find, name ) and render( mode ) }
      path( :update, :put => [ :resource, :name ] ) { action( :update, name ) and redirect( paths.read( name ) ) }
      path( :delete, :delete => [ :resource, :name ] ) { action( :delete, name ) }
      
    end  

  end

end
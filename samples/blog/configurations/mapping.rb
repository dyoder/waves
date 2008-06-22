module Blog

  module Configurations

    module Mapping
      
      extend Waves::Mapping
      
      # specific to comments - on create redirect to the entry, not the comment itself
      path :create, :resource => :comment, :post => [ :comments ] do
        redirect( Blog::Resources::Entries.paths.show( action( :create ).entry.name ) )
      end
      
      # defaults for generic resources
      path( :list, :get => [ :resources ] ) { action( :all ) and render( :list ) }
      path( :show, :get => [ :resource, :name ] ) { action( :find, name ) and render( :show ) }
      path( :edit, :get => [ :resource, :name, :view ] ) { action( :find, name ) and render( view ) }
      path( :create, :post => [ :resources ] ) { redirect( paths.edit( action( :create ).name ) ) }
      path( :update, :post => [ :resource, :name ] ) { action( :update, name ) and redirect( paths.show( name ) ) }
      path( :delete, :delete => [ :resource, :name ] ) { action( :delete, name ) }
      
    end  

  end

end
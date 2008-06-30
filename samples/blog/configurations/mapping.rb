module Blog

  module Configurations

    module Mapping
      
      extend Waves::Mapping
      
      # specific to comments - on create redirect to the entry, not the comment itself
      action :create, :resource => :comment, :post => [ '/comments' ] do
        redirect( Blog::Resources::Entries.paths.read( action( :create ).entry.name ) )
      end
      
      # defaults for generic resources
      action( :list, :get => [ :resources ] ) { action( :all ) and render( :list ) }
      action( :create, :post => [ :resources ] ) { redirect( paths.read( action( :create ).name, 'edit' ) ) }
      action( :read, :get => [ :resource, :name, { :mode => 'show' } ] ) { action( :find, name ) and render( mode ) }
      action( :update, :put => [ :resource, :name ] ) { action( :update, name ) and redirect( paths.read( name ) ) }
      action( :delete, :delete => [ :resource, :name ] ) { action( :delete, name ) }
      
    end  

  end

end
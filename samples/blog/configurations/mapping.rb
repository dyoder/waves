module Blog

  module Configurations

    module Mapping
      
      extend Waves::Mapping
      
      response( :get => [] ) { redirect "/waves/status"}
      response( :get => [ "waves", "status" ]) { render "waves/status" }
      
      # specific to comments - on create redirect to the entry, not the comment itself
      response :create, :resource => :comment, :post => [ 'comments' ] do
        redirect( Blog.paths( :entry ).read( controller( :create ).entry.name ) )
      end
      
      # defaults for generic resources
      response( :list, :get => [ :resources ] ) { controller( :all ) and view( :list ) }
      response( :create, :post => [ :resources ] ) { redirect( paths.read( controller( :create ).name, 'edit' ) ) }
      response( :read, :get => [ :resource, :name, { :mode => 'show' } ] ) { controller( :find, name ) and view( mode ) }
      response( :update, :put => [ :resource, :name ] ) { controller( :update, name ) and redirect( paths.read( name ) ) }
      response( :delete, :delete => [ :resource, :name ] ) { controller( :delete, name ) }
      
    end  

  end

end
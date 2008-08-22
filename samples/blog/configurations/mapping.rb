module Blog

  module Configurations

    module Mapping
      
      extend Waves::Mapping
      
      on( :get => [] ) { redirect "/waves/status"}
      on( :get => [ "waves", "status" ]) { render "waves/status" }
      
      # specific to comments - on create redirect to the entry, not the comment itself
      on :post => [ 'comments' ], :resource => :comment, :as => :create do
        redirect( paths( :entry ).read( controller( :create ).entry.name ) )
      end
      
      # defaults for generic resources
      on( :get => [ :resources ], :as => :list ) { controller( :all ) and view( :list ) }
      on( :post => [ :resources ], :as => :create ) { redirect( paths.read( controller( :create ).name, 'edit' ) ) }
      on( :get => [ :resource, :name, { :mode => 'show' } ], :as => :read ) { controller( :find, name ) and view( mode ) }
      on( :put => [ :resource, :name ], :as => :update ) { controller( :update, name ) and redirect( paths.read( name ) ) }
      on( :delete => [ :resource, :name ], :as => :delete ) { controller( :delete, name ) }
      
    end  

  end

end
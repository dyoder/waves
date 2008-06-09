module Blog

  module Configurations

    module Mapping
      
      extend Waves::Mapping
      
      # specific to comments - on create redirect to the entry, not the comment itself
      path :create, :resource => :comment, :post => '/comments' do
        instance = create and redirect( Blog::Resources::Entries.path.show( instance.entry.name ) )
      end
      
      # defaults for generic resources
      path :list, :get => '/<resources>' { all and render( :list ) }
      path :show, :get => '/<resource>/<name>' { find( params[:name] ) and render( :show ) }
      path :edit, :get => '/<resource>/<name>/editor' { find( params[:name] ) and render( :editor ) }
      path :create, :post => '/<resources>' { instance = create and redirect( path.editor( instance.name ) ) }
      path :update, :post => '/<resource>/<name>' { update( params[:name] ) and redirect( path.show( params[:name] ) ) }
      path :delete, :delete => '/<resource><name>' { delete( params[:name] ) }
      
    end  

  end

end

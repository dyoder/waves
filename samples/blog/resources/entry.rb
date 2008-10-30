module Blog
  module Resources
    class Entry < Default
      include Waves::Resources::Mixin
      
      on :get, :list => [ 'entries' ] do
        view.list( plural => controller.all )
      end
            
      on :get, :show => [ 'entry', :name ] do
        view.show( :entry => controller.find( captured.name ) )
      end
      
      on :get, :edit => [ 'entry', :name, 'edit' ] do
        view.edit( singular => controller.find( captured.name ) )
      end
      
      on :put, :update => [ 'entry', :name ] do
        controller.update( captured.name )
        redirect "/entry/#{captured.name}"
      end
      
      on :post, :create => [ 'entry' ] do
        redirect "/entry/#{controller.create.name}/edit"
      end
      
      on :post, :comment => [ 'entry', :name ] do
        entry = controller.find( captured.name )
        entry.add_comment( Models::Comment.create( query.comment.to_hash ) )
        session[:commenter] = query.comment.name
        redirect request.path
      end
      
      on :delete, [ 'entry', :name ] do
        controller.delete( captured.name )
        redirect "/entry"
      end
      
    end
  end
end

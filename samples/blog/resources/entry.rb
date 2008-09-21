module Blog
  module Resources
    class Entry < Default
      
      
      on :get, :list => [ 'entry' ] do
        view.list( plural => controller.all )
      end
      
      on :get, :show => [ 'entry', :name ] do
        view.show( singular => controller.find( query.name ) )
      end
      
      on :get, :edit => [ 'entry', :name, 'edit' ] do
        view.edit( singular => controller.find( query.name ) )
      end
      
      on :put, :update => [ 'entry', :name ] do
        controller.update( query.name )
        redirect  "/entry/#{query.name}"
      end
      
      on :post, :create => [ 'entry' ] do
        redirect "/entry/#{controller.create.name}/edit"
      end
      
      on :post, :comment => [ 'entry', :name ] do
        entry = controller.find( query.name )
        comment = Models::Comment.create( query.comment.to_hash )
        entry.add_comment( comment )
        redirect request.path
      end
      
    end
  end
end

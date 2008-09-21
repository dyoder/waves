module Blog
  module Resources
    class Entry < Default

      raise "got to resource"

      on :get, :list => [ ] do
        raise  "list"
      end
      
      on :get, :show => [ :name ] do
        raise "show: #{captured.name}"
      end
      
      # 
      # on :get, :list => [ ] do
      #   view.list( plural => controller.all )
      # end
      # 
      # on :get, :show => [ :name ] do
      #   view.show( singular => controller.find( query.name ) )
      # end
      # 
      # on :get, :edit => [ :name, 'edit' ] do
      #   view.edit( singular => controller.find( query.name ) )
      # end
      # 
      # on :put, :update => [ :name ] do
      #   controller.update( query.name )
      #   redirect  "/entry/#{query.name}"
      # end
      # 
      # on :post, :create => [ ] do
      #   redirect "/entry/#{controller.create.name}/edit"
      # end
      # 
      # on :post, :comment => [ :name ] do
      #   entry = controller.find( query.name )
      #   comment = Models::Comment.create( query.comment.to_hash )
      #   entry.add_comment( comment )
      #   redirect request.path
      # end
      
    end
  end
end

module Blog
  module Resources
    class Entry < Default
      
      on :get, :list => [ ] do
        view.list( plural => controller.all )
      end

      on :get, :show => [ :name ] do
        view.show( singular => controller.find( query.name ) )
      end
      
      on :get, :edit => [ :name, 'edit' ] do
        view.edit( singular => controller.find( query.name ) )
      end
      
      on :put, :update => [ :name ] do
        controller.update( query.name )
        redirect  "/entry/#{query.name}"
      end
      
      on :post, :create => [ ] do
        i = controller.create
        redirect "/entry/#{i.name}/edit"
      end
      

      
    end
  end
end

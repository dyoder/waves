module Blog
  module Resources
    class Entry < Default
      include Waves::Resources::Mixin
      
      def basic_auth
        raise Waves::Dispatchers::Unauthorized unless auth = @request.http_variable('Authorization')
        # Header value should look like: "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=="
        scheme, credentials = auth.split(' ', 2)
        raise Waves::Dispatchers::BadRequest unless scheme == "Basic"
        # "m*" is the code for Base64
        # decoded value looks like "user:password"
        credentials.unpack("m*").first.split(/:/, 2)
      end
      
      before do
        return if @request.method == :get
        @user, @pass = basic_auth
        authenticate(*basic_auth)
      end
      
      def authenticate(user, password)
        raise Waves::Dispatchers::Unauthorized unless user.reverse == password
      end
      
      
      on :get, :list => [ /entry|entries/ ] do
        view.list( plural => controller.all )
      end
      
      on :get, :show => [ 'entry', :name ] do
        view.show( :entry => controller.find( captured.name ) )
      end
      
      on :get, :edit => [ 'entry', :name, 'edit' ] do
        view.edit( singular => controller.find( captured.name ) )
      end
      
      on :put, :update => [ 'entry', :name ] do
        begin
          controller.update( captured.name )
        rescue Waves::Dispatchers::NotFoundError
          controller.create
        end
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

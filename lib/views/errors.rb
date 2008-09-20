module Waves
  module Views
    class Errors < Waves::Views::Base
      
      module Helpers
        def header( title )
          head do
            self.title title
            style do
              text 'body { background: #933; padding: 20px; font-family: verdana, sans-serif; }'
              text 'h1 { font-size: 60px; font-weight: bold; }'
              text 'p { font-size: 24px; }'
            end
          end
        end
      end
      
      def builder( &block )
        builder = Markaby::Builder.new
        builder.meta_eval { include Waves::Helpers::BuiltIn ; include Helpers }
        builder.instance_eval( &block )
        builder.to_s
      end
      
      def not_found_404
        builder do
          doctype( :html4_transitional )
          html do
            header( '404: Not Found' )
            body do
              h1 '404'
              p %q( That URL does not exist on this server. )
            end
          end
        end
      end
      
      def server_error_500
        builder do
          doctype( :html4_transitional )
          html do
            header( '500: Server Error' )
            body do
              h1 '500'
              p %q( Internal server error. Sorry, but your request could not be processed. )
            end
          end
        end
      end
    end
  end
end
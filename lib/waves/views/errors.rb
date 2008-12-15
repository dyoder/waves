require 'waves/helpers/doc_type'

module Waves
  module Views
    class Errors < Waves::Views::Base
      
      include Waves::Helpers::DocType
      
      def header( title )
        <<-HTML
        <head>
          <title>#{title}</title>
          <style>
            body { background: #933; padding: 20px; font-family: verdana, sans-serif; }
            h1 { font-size: 60px; font-weight: bold; }
            p { font-size: 24px; }
          </style>
        </head>
        HTML
      end
    
      def not_found_404
        DOCTYPES[ :html4_transitional ]
        <<-HTML
        <html>
          #{ header( '404: Not Found' ) }
          <body>
            <h1>404</h1>
            <p>That URL does not exist on this server.</p>
          </body>
        </html>
        HTML
      end
    
      def server_error_500
        DOCTYPES[ :html4_transitional ]
        <<-HTML
        <html>
          #{ header( '500: Server Error' ) }
          <body>
            <h1>500</h1>
            <p>Internal server error. Sorry, but your request could not be processed.</p>
          </body>
        </html>
        HTML
      end

    end
  end
end

module Blog

  module Configurations

    module Mapping
      extend Waves::Mapping

      path '/comments', :method => :post do
        resource( :comment ) do
          controller { comment = create; redirect( "/entry/#{comment.entry.name}" ) }
        end
      end
      include Waves::Mapping::PrettyUrls::RestRules
      include Waves::Mapping::PrettyUrls::GetRules
    end

  end

end

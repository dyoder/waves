module Blog

  module Configurations

    module Mapping
      extend Waves::Mapping

      path '/comments', :method => :post do
        redirect( named.get( :model => :entry, :name => controllers[:comment].create.name ) )
      end
      include Waves::Mapping::PrettyUrls::RestRules
      include Waves::Mapping::PrettyUrls::GetRules
    end

  end

end

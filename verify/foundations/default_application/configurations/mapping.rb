module DefaultApplication

  module Configurations

    module Mapping
      extend Waves::Mapping
      path( "/user-added") { response.body = "User added mapping"}
      include Waves::Mapping::PrettyUrls::RestRules
      include Waves::Mapping::PrettyUrls::GetRules
    end

  end

end

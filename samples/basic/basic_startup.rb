require "autocode"

here  = File.dirname __FILE__
waves = ENV["WAVES"] || File.join(here, "waves", "lib")

# Primitive startup file while developing the path matcher.
#
module Basic

  # Register.
  #
  Waves << self

  # All of our resources live here.
  #
  module Resources
    include AutoCode

    auto_load true, :directories => "resources"

    # First-tier resource mapper.
    #
    class Main
      include Waves::Resources::Mixin

      on(:get, "moomin") { "Hi!" }
      on(:get, "moomin", "there") { "Hi there!" }

      # E.g. /moomin/wherever
      on(:get, "moomin", :elsewhere) { "Hi #{captured.elsewhere}!" }

      # E.g. /moomin/hobbies/football/medals or
      #      /moomin/hobbies/football/regional/medals
      on(:get, "moomin", "hobbies", 1..2, "medals") { "No medals :/" }

    end
  end


  # Configuration settings.
  #
  module Configurations

    # Sane default config. Can be run standalone or from rackup.
    #
    class Development < Waves::Configurations::Default
      reloadable [Basic::Resources]

      # When running standalone.
      server    Waves::Servers::Mongrel
      host      "127.0.0.1"
      port      8080

      resource  Basic::Resources::Main

      application {
        use Rack::ShowExceptions
        use Rack::Static, :urls => %w[ /favicon.ico ],
                          :root => "public"
        run Waves::Dispatchers::Fast.new
      }
    end

    class Production < Development
    end

  end

end


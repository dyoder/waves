# External Dependencies
require 'rubygems'

# Some scripts need to be able to locate items relative to waves source.
WAVES = "#{File.dirname(__FILE__)}/.." unless defined?(WAVES)

require 'rack'
require 'daemons'
require 'live_console'
require 'autocode'

# for mimetypes only or when using as default handler
require 'mongrel'

# a bunch of handy stuff
require 'extensions/all'
require 'fileutils'
require 'metaid'
require 'forwardable'
require 'date'
require 'benchmark'
# require 'memcache'
require 'base64'

# selected project-specific extensions
require 'utilities/module'
require 'utilities/string'
require 'utilities/symbol'
require 'utilities/object'
require 'utilities/integer'
require 'utilities/inflect'
require 'utilities/inflect/english'
require 'utilities/proc'
require 'utilities/hash'
require 'utilities/attributes'
# waves Runtime
require 'dispatchers/base'
require 'dispatchers/default'
require 'runtime/logger'
require 'runtime/mime_types'
require 'runtime/application'
require 'runtime/console'
require 'runtime/debugger'
require 'runtime/server'
require 'runtime/request'
require 'runtime/response'
require 'runtime/response_mixin'
require 'runtime/response_proxy'
require 'runtime/session'
require 'runtime/blackboard'
require 'runtime/configuration'

# waves URI mapping
require 'mapping/mapping'
require 'mapping/pretty_urls'

# waves mvc support
require 'controllers/mixin'
require 'controllers/base'
require 'views/mixin'
require 'views/base'
require 'helpers/tag_helper'
require 'helpers/url_helper'
require 'helpers/common'
require 'helpers/form'
require 'helpers/formatting'
require 'helpers/model'
require 'helpers/view'
require 'helpers/default'
require 'helpers/asset_helper'
require 'helpers/number_helper'
require 'renderers/mixin'
require 'renderers/erubis'
require 'renderers/markaby'


# waves foundations / layers
require 'layers/simple'
require 'layers/simple_errors'
require 'foundations/simple'
require 'layers/mvc'
require 'layers/default_errors'
require 'foundations/default'

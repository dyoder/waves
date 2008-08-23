# External Dependencies
require 'rubygems'

# Some scripts need to be able to locate items relative to waves source.
WAVES = "#{File.dirname(__FILE__)}/.." unless defined?(WAVES)

require 'rack'
require 'daemons'
require 'live_console'

gem 'dyoder-autocode'
require 'autocode'
require 'functor'

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

gem 'dyoder-filebase'
require 'filebase'
require 'filebase/model'

# selected project-specific extensions
require 'utilities/module'
require 'utilities/string'
require 'utilities/symbol'
require 'utilities/object'
require 'utilities/integer'
require 'utilities/inflect'
require 'utilities/proc'
require 'utilities/hash'
require 'utilities/tempfile'
require 'utilities/kernel'
# waves Runtime
require 'dispatchers/base'
require 'dispatchers/default'
require 'runtime/logger'
require 'runtime/mime_types'
require 'runtime/runtime'
require 'runtime/console'
require 'runtime/server'
require 'runtime/request'
require 'runtime/response'
require 'runtime/response_mixin'
require 'runtime/session'
require 'runtime/blackboard'
require 'runtime/configuration'

# waves URI mapping
require 'mapping/mapping'
require 'mapping/action'
require 'mapping/handler'
require 'mapping/pattern'
require 'mapping/constraints'
require 'mapping/descriptors'
require 'mapping/paths'
require 'resources/mixin'
require 'resources/proxy'

# waves mvc support
require 'controllers/mixin'
require 'views/mixin'
# require 'helpers/tag_helper'
# require 'helpers/url_helper'
require 'helpers/common'
require 'helpers/form'
require 'helpers/formatting'
require 'helpers/model'
require 'helpers/view'
require 'helpers/built_in'
# require 'helpers/asset_helper'
# require 'helpers/number_helper'
require 'renderers/mixin'
require 'renderers/erubis'
require 'renderers/markaby'
require 'renderers/haml'


# waves foundations / layers
require 'layers/simple'
require 'layers/simple_errors'
require 'foundations/simple'
require 'layers/mvc'
require 'layers/default_errors'
require 'layers/inflect/english'
require 'foundations/default'

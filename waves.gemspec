Gem::Specification.new do |s|
  s.name = %q{waves}
  s.version = "0.7.5"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder"]
  s.date = %q{2008-06-17}
  s.email = %q{dan@zeraweb.com}
  s.executables = ["waves", "waves-server", "waves-console"]
  s.files = ["lib/commands/waves-console.rb", "lib/commands/waves-server.rb", "lib/controllers/base.rb", "lib/controllers/mixin.rb", "lib/dispatchers/base.rb", "lib/dispatchers/default.rb", "lib/foundations/default.rb", "lib/foundations/simple.rb", "lib/helpers/common.rb", "lib/helpers/default.rb", "lib/helpers/form.rb", "lib/helpers/formatting.rb", "lib/helpers/model.rb", "lib/helpers/view.rb", "lib/layers/default_errors.rb", "lib/layers/mvc.rb", "lib/layers/orm/active_record/tasks/schema.rb", "lib/layers/orm/active_record.rb", "lib/layers/orm/data_mapper.rb", "lib/layers/orm/filebase.rb", "lib/layers/orm/migration.rb", "lib/layers/orm/sequel/tasks/schema.rb", "lib/layers/orm/sequel.rb", "lib/layers/simple.rb", "lib/layers/simple_errors.rb", "lib/mapping/mapping.rb", "lib/mapping/pretty_urls.rb", "lib/renderers/erubis.rb", "lib/renderers/markaby.rb", "lib/renderers/mixin.rb", "lib/runtime/application.rb", "lib/runtime/blackboard.rb", "lib/runtime/configuration.rb", "lib/runtime/console.rb", "lib/runtime/debugger.rb", "lib/runtime/logger.rb", "lib/runtime/mime_types.rb", "lib/runtime/request.rb", "lib/runtime/response.rb", "lib/runtime/response_mixin.rb", "lib/runtime/response_proxy.rb", "lib/runtime/server.rb", "lib/runtime/session.rb", "lib/tasks/cluster.rb", "lib/tasks/gem.rb", "lib/tasks/generate.rb", "lib/utilities/hash.rb", "lib/utilities/inflect.rb", "lib/utilities/integer.rb", "lib/utilities/kernel.rb", "lib/utilities/module.rb", "lib/utilities/object.rb", "lib/utilities/proc.rb", "lib/utilities/string.rb", "lib/utilities/symbol.rb", "lib/views/base.rb", "lib/views/mixin.rb", "lib/waves.rb", "lib/layers/orm/active_record/migrations/empty.rb.erb", "lib/layers/orm/sequel/migrations/empty.rb.erb", "app/bin", "app/bin/waves-console", "app/bin/waves-server", "app/configurations", "app/configurations/development.rb.erb", "app/configurations/mapping.rb.erb", "app/configurations/production.rb.erb", "app/controllers", "app/doc", "app/helpers", "app/lib", "app/lib/application.rb.erb", "app/lib/tasks", "app/log", "app/models", "app/public", "app/public/css", "app/public/flash", "app/public/images", "app/public/javascript", "app/Rakefile", "app/schema", "app/schema/migrations", "app/startup.rb", "app/templates", "app/templates/errors", "app/templates/errors/not_found_404.mab", "app/templates/errors/server_error_500.mab", "app/templates/layouts", "app/templates/layouts/default.mab", "app/tmp", "app/tmp/sessions", "app/views", "bin/waves", "bin/waves-server", "bin/waves-console"]
  s.has_rdoc = true
  s.homepage = %q{http://rubywaves.com}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{Open-source framework for building Ruby-based Web applications.}

  s.add_dependency(%q<mongrel>, [">= 0"])
  s.add_dependency(%q<rack>, [">= 0"])
  s.add_dependency(%q<markaby>, [">= 0"])
  s.add_dependency(%q<erubis>, [">= 0"])
  s.add_dependency(%q<RedCloth>, [">= 0"])
  s.add_dependency(%q<autocode>, [">= 0"])
  s.add_dependency(%q<extensions>, [">= 0"])
  s.add_dependency(%q<live_console>, [">= 0"])
  s.add_dependency(%q<choice>, [">= 0"])
  s.add_dependency(%q<daemons>, [">= 0"])
  s.add_dependency(%q<rakegen>, [">= 0"])
  s.add_dependency(%q<sequel>, [">= 2.0.0"])
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{waves}
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder"]
  s.date = %q{2008-10-03}
  s.email = %q{dan@zeraweb.com}
  s.executables = ["waves", "waves-server", "waves-console"]
  s.files = ["app/configurations", "app/configurations/default.rb.erb", "app/configurations/development.rb.erb", "app/configurations/production.rb.erb", "app/controllers", "app/helpers", "app/lib", "app/lib/application.rb.erb", "app/lib/tasks", "app/log", "app/models", "app/public", "app/public/css", "app/public/flash", "app/public/images", "app/public/javascript", "app/Rakefile", "app/resources", "app/schema", "app/schema/migrations", "app/startup.rb", "app/templates", "app/templates/errors", "app/templates/errors/not_found_404.mab", "app/templates/errors/server_error_500.mab", "app/templates/layouts", "app/templates/layouts/default.mab", "app/tmp", "app/tmp/sessions", "app/views", "app/controllers/.gitignore", "app/helpers/.gitignore", "app/lib/tasks/.gitignore", "app/log/.gitignore", "app/models/.gitignore", "app/public/css/.gitignore", "app/public/flash/.gitignore", "app/public/images/.gitignore", "app/public/javascript/.gitignore", "app/resources/.gitignore", "app/schema/migrations/.gitignore", "app/tmp/sessions/.gitignore", "app/views/.gitignore", "lib/cache/cache-ipi.rb", "lib/cache/cache.rb", "lib/commands/waves-console.rb", "lib/commands/waves-server.rb", "lib/controllers/mixin.rb", "lib/dispatchers/base.rb", "lib/dispatchers/default.rb", "lib/ext/float.rb", "lib/ext/hash.rb", "lib/ext/inflect.rb", "lib/ext/integer.rb", "lib/ext/kernel.rb", "lib/ext/module.rb", "lib/ext/object.rb", "lib/ext/proc.rb", "lib/ext/string.rb", "lib/ext/symbol.rb", "lib/ext/tempfile.rb", "lib/foundations/classic.rb", "lib/foundations/compact.rb", "lib/helpers/basic.rb", "lib/helpers/doc_type.rb", "lib/helpers/extended.rb", "lib/helpers/form.rb", "lib/helpers/formatting.rb", "lib/helpers/layouts.rb", "lib/helpers/model.rb", "lib/helpers/view.rb", "lib/layers/cache/file/file-ipi.rb", "lib/layers/cache/file.rb", "lib/layers/cache/memcached/memcached-ipi.rb", "lib/layers/cache/memcached.rb", "lib/layers/default_errors.rb", "lib/layers/inflect/english/rules.rb", "lib/layers/inflect/english/string.rb", "lib/layers/inflect/english.rb", "lib/layers/mvc.rb", "lib/layers/orm/active_record/tasks/generate.rb", "lib/layers/orm/active_record/tasks/schema.rb", "lib/layers/orm/active_record.rb", "lib/layers/orm/data_mapper.rb", "lib/layers/orm/filebase.rb", "lib/layers/orm/migration.rb", "lib/layers/orm/sequel/tasks/generate.rb", "lib/layers/orm/sequel/tasks/schema.rb", "lib/layers/orm/sequel.rb", "lib/layers/renderers/erubis.rb", "lib/layers/renderers/haml.rb", "lib/layers/renderers/markaby.rb", "lib/matchers/accept.rb", "lib/matchers/base.rb", "lib/matchers/content_type.rb", "lib/matchers/path.rb", "lib/matchers/query.rb", "lib/matchers/request.rb", "lib/matchers/resource.rb", "lib/matchers/traits.rb", "lib/matchers/uri.rb", "lib/renderers/mixin.rb", "lib/resources/mixin.rb", "lib/resources/paths.rb", "lib/runtime/configuration.rb", "lib/runtime/console.rb", "lib/runtime/logger.rb", "lib/runtime/mime_types.rb", "lib/runtime/request.rb", "lib/runtime/response.rb", "lib/runtime/response_mixin.rb", "lib/runtime/runtime.rb", "lib/runtime/server.rb", "lib/runtime/session.rb", "lib/tasks/cluster.rb", "lib/tasks/gem.rb", "lib/tasks/generate.rb", "lib/views/errors.rb", "lib/views/mixin.rb", "lib/waves.rb", "lib/layers/orm/active_record/migrations/empty.rb.erb", "lib/layers/orm/sequel/migrations/empty.rb.erb", "doc/HISTORY", "doc/LICENSE", "doc/tutorials", "doc/tutorials/blog1.textile", "doc/tutorials/blog2.textile", "doc/tutorials/blog3.textile", "doc/tutorials/blog4.textile", "doc/VERSION", "samples/blog", "samples/blog/blog.db", "samples/blog/configurations", "samples/blog/configurations/default.rb", "samples/blog/configurations/development.rb", "samples/blog/configurations/mapping.rb", "samples/blog/configurations/production.rb", "samples/blog/controllers", "samples/blog/doc", "samples/blog/doc/EMTPY", "samples/blog/helpers", "samples/blog/lib", "samples/blog/lib/application.rb", "samples/blog/lib/tasks", "samples/blog/log", "samples/blog/models", "samples/blog/models/comment.rb", "samples/blog/models/entry.rb", "samples/blog/public", "samples/blog/public/css", "samples/blog/public/css/site.css", "samples/blog/public/flash", "samples/blog/public/images", "samples/blog/public/images/wipeout.gif", "samples/blog/public/javascript", "samples/blog/public/javascript/jquery-1.2.6.min.js", "samples/blog/public/javascript/site.js", "samples/blog/Rakefile", "samples/blog/resources", "samples/blog/resources/entry.rb", "samples/blog/resources/map.rb", "samples/blog/schema", "samples/blog/schema/migrations", "samples/blog/schema/migrations/001_initial_schema.rb", "samples/blog/schema/migrations/002_add_comments.rb", "samples/blog/schema/migrations/templates", "samples/blog/schema/migrations/templates/empty.rb.erb", "samples/blog/startup.rb", "samples/blog/templates", "samples/blog/templates/comment", "samples/blog/templates/comment/add.mab", "samples/blog/templates/comment/list.mab", "samples/blog/templates/entry", "samples/blog/templates/entry/edit.mab", "samples/blog/templates/entry/list.mab", "samples/blog/templates/entry/show.mab", "samples/blog/templates/entry/summary.mab", "samples/blog/templates/errors", "samples/blog/templates/errors/not_found_404.mab", "samples/blog/templates/errors/server_error_500.mab", "samples/blog/templates/layouts", "samples/blog/templates/layouts/default.mab", "samples/blog/templates/waves", "samples/blog/templates/waves/status.mab", "samples/blog/tmp", "samples/blog/tmp/sessions", "samples/blog/views", "samples/blog/waves-console", "samples/blog/waves-server", "verify/helpers.rb", "verify/layers", "verify/layers/cache", "verify/layers/cache/file-ipi.rb", "verify/layers/cache/helpers.rb", "verify/layers/helpers.rb", "verify/layers/obsolete_cache", "verify/layers/obsolete_cache/file-ipi.rb", "verify/layers/obsolete_cache/file_cache.rb", "verify/layers/obsolete_cache/helpers.rb", "verify/layers/obsolete_cache/memcached.rb", "verify/specs", "verify/specs/app_generation", "verify/specs/app_generation/helpers.rb", "verify/specs/app_generation/startup.rb", "verify/specs/configurations", "verify/specs/configurations/attributes.rb", "verify/specs/configurations/helpers.rb", "verify/specs/configurations/rack_integration.rb", "verify/specs/foundations", "verify/specs/foundations/helpers.rb", "verify/specs/foundations/simple.rb", "verify/specs/layers", "verify/specs/layers/data_mapper", "verify/specs/layers/data_mapper/track_feature.rb", "verify/specs/layers/default_errors.rb", "verify/specs/layers/helpers.rb", "verify/specs/layers/migration.rb", "verify/specs/layers/sequel", "verify/specs/layers/sequel/model.rb", "verify/specs/layers/sequeltest.db", "verify/tests", "verify/tests/cache", "verify/tests/cache/cache.rb", "verify/tests/cache/helpers.rb", "verify/tests/controllers", "verify/tests/controllers/helpers.rb", "verify/tests/controllers/interface.rb", "verify/tests/core", "verify/tests/core/application.rb", "verify/tests/core/helpers.rb", "verify/tests/core/response_mixin.rb", "verify/tests/core/runtime.rb", "verify/tests/core/track_feature.rb", "verify/tests/core/utilities.rb", "verify/tests/matchers", "verify/tests/matchers/helpers.rb", "verify/tests/matchers/path.rb", "verify/tests/obsolete_mapping", "verify/tests/obsolete_mapping/constraint_matching.rb", "verify/tests/obsolete_mapping/evaluation.rb", "verify/tests/obsolete_mapping/exception_handler.rb", "verify/tests/obsolete_mapping/helpers.rb", "verify/tests/obsolete_mapping/pattern_matching.rb", "verify/tests/obsolete_mapping/query_params.rb", "verify/tests/obsolete_mapping/story.txt", "verify/tests/obsolete_mapping/wrappers.rb", "verify/tests/requests", "verify/tests/requests/accept.rb", "verify/tests/requests/helpers.rb", "verify/tests/requests/request.rb", "verify/tests/requests/response.rb", "verify/tests/requests/session.rb", "verify/tests/views", "verify/tests/views/helpers.rb", "verify/tests/views/rendering.rb", "verify/tests/views/templates", "verify/tests/views/templates/foo.erb", "verify/tests/views/templates/moo.erb", "verify/tests/views/templates/moo.mab", "bin/waves", "bin/waves-server", "bin/waves-console"]
  s.has_rdoc = true
  s.homepage = %q{http://rubywaves.com}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{waves}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Open-source framework for building Ruby-based Web applications.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongrel>, [">= 0"])
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_runtime_dependency(%q<markaby>, [">= 0"])
      s.add_runtime_dependency(%q<erubis>, [">= 0"])
      s.add_runtime_dependency(%q<haml>, [">= 0"])
      s.add_runtime_dependency(%q<metaid>, [">= 0"])
      s.add_runtime_dependency(%q<extensions>, [">= 0"])
      s.add_runtime_dependency(%q<live_console>, [">= 0"])
      s.add_runtime_dependency(%q<choice>, [">= 0"])
      s.add_runtime_dependency(%q<daemons>, [">= 0"])
      s.add_runtime_dependency(%q<functor>, [">= 0"])
      s.add_runtime_dependency(%q<rakegen>, [">= 0.6.6"])
      s.add_runtime_dependency(%q<sequel>, [">= 2.0.0"])
      s.add_runtime_dependency(%q<autocode>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<dyoder-filebase>, [">= 0.3.4"])
      s.add_runtime_dependency(%q<dyoder-functor>, [">= 0.5.0"])
      s.add_runtime_dependency(%q<RedCloth>, [">= 4.0.0"])
    else
      s.add_dependency(%q<mongrel>, [">= 0"])
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<markaby>, [">= 0"])
      s.add_dependency(%q<erubis>, [">= 0"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<metaid>, [">= 0"])
      s.add_dependency(%q<extensions>, [">= 0"])
      s.add_dependency(%q<live_console>, [">= 0"])
      s.add_dependency(%q<choice>, [">= 0"])
      s.add_dependency(%q<daemons>, [">= 0"])
      s.add_dependency(%q<functor>, [">= 0"])
      s.add_dependency(%q<rakegen>, [">= 0.6.6"])
      s.add_dependency(%q<sequel>, [">= 2.0.0"])
      s.add_dependency(%q<autocode>, [">= 1.0.0"])
      s.add_dependency(%q<dyoder-filebase>, [">= 0.3.4"])
      s.add_dependency(%q<dyoder-functor>, [">= 0.5.0"])
      s.add_dependency(%q<RedCloth>, [">= 4.0.0"])
    end
  else
    s.add_dependency(%q<mongrel>, [">= 0"])
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<markaby>, [">= 0"])
    s.add_dependency(%q<erubis>, [">= 0"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<metaid>, [">= 0"])
    s.add_dependency(%q<extensions>, [">= 0"])
    s.add_dependency(%q<live_console>, [">= 0"])
    s.add_dependency(%q<choice>, [">= 0"])
    s.add_dependency(%q<daemons>, [">= 0"])
    s.add_dependency(%q<functor>, [">= 0"])
    s.add_dependency(%q<rakegen>, [">= 0.6.6"])
    s.add_dependency(%q<sequel>, [">= 2.0.0"])
    s.add_dependency(%q<autocode>, [">= 1.0.0"])
    s.add_dependency(%q<dyoder-filebase>, [">= 0.3.4"])
    s.add_dependency(%q<dyoder-functor>, [">= 0.5.0"])
    s.add_dependency(%q<RedCloth>, [">= 4.0.0"])
  end
end

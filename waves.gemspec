Gem::Specification.new do |s|
  s.name = %q{waves}
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder"]
  s.date = %q{2008-10-26}
  s.default_executable = %q{waves}
  s.email = %q{dan@zeraweb.com}
  s.executables = ["waves"]
  s.files = ["lib/caches/file.rb", "lib/caches/memcached.rb", "lib/caches/simple.rb", "lib/caches/synchronized.rb", "lib/commands/console.rb", "lib/commands/generate.rb", "lib/commands/help.rb", "lib/commands/server.rb", "lib/dispatchers/base.rb", "lib/dispatchers/default.rb", "lib/ext/float.rb", "lib/ext/hash.rb", "lib/ext/integer.rb", "lib/ext/kernel.rb", "lib/ext/module.rb", "lib/ext/object.rb", "lib/ext/string.rb", "lib/ext/symbol.rb", "lib/ext/tempfile.rb", "lib/foundations/classic.rb", "lib/foundations/compact.rb", "lib/helpers/basic.rb", "lib/helpers/doc_type.rb", "lib/helpers/extended.rb", "lib/helpers/form.rb", "lib/helpers/formatting.rb", "lib/helpers/layouts.rb", "lib/helpers/model.rb", "lib/helpers/view.rb", "lib/layers/inflect/english.rb", "lib/layers/mvc/controllers.rb", "lib/layers/mvc/extensions.rb", "lib/layers/mvc.rb", "lib/layers/orm/active_record/tasks/generate.rb", "lib/layers/orm/active_record/tasks/schema.rb", "lib/layers/orm/active_record.rb", "lib/layers/orm/data_mapper.rb", "lib/layers/orm/filebase.rb", "lib/layers/orm/migration.rb", "lib/layers/orm/sequel/tasks/generate.rb", "lib/layers/orm/sequel/tasks/schema.rb", "lib/layers/orm/sequel.rb", "lib/layers/renderers/erubis.rb", "lib/layers/renderers/haml.rb", "lib/layers/renderers/markaby.rb", "lib/matchers/accept.rb", "lib/matchers/base.rb", "lib/matchers/content_type.rb", "lib/matchers/path.rb", "lib/matchers/query.rb", "lib/matchers/request.rb", "lib/matchers/resource.rb", "lib/matchers/traits.rb", "lib/matchers/uri.rb", "lib/renderers/mixin.rb", "lib/resources/mixin.rb", "lib/resources/paths.rb", "lib/runtime/bench.rb", "lib/runtime/configuration.rb", "lib/runtime/console.rb", "lib/runtime/logger.rb", "lib/runtime/mime_types.rb", "lib/runtime/mock_mixin.rb", "lib/runtime/monitor.rb", "lib/runtime/request.rb", "lib/runtime/response.rb", "lib/runtime/response_mixin.rb", "lib/runtime/runtime.rb", "lib/runtime/server.rb", "lib/runtime/session.rb", "lib/runtime/worker.rb", "lib/servers/base.rb", "lib/servers/mongrel.rb", "lib/servers/webrick.rb", "lib/tasks/gem.rb", "lib/tasks/generate.rb", "lib/tasks/manager.rb", "lib/views/errors.rb", "lib/views/mixin.rb", "lib/waves.rb", "lib/layers/orm/active_record/migrations/empty.rb.erb", "lib/layers/orm/sequel/migrations/empty.rb.erb", "doc/HISTORY", "doc/LICENSE", "doc/README", "doc/VERSION", "samples/blog", "samples/blog/blog.db", "samples/blog/configurations", "samples/blog/configurations/default.rb", "samples/blog/configurations/development.rb", "samples/blog/configurations/production.rb", "samples/blog/lib", "samples/blog/lib/application.rb", "samples/blog/models", "samples/blog/models/comment.rb", "samples/blog/models/entry.rb", "samples/blog/public", "samples/blog/public/css", "samples/blog/public/css/site.css", "samples/blog/public/javascript", "samples/blog/public/javascript/jquery-1.2.6.min.js", "samples/blog/public/javascript/site.js", "samples/blog/Rakefile", "samples/blog/resources", "samples/blog/resources/entry.rb", "samples/blog/resources/map.rb", "samples/blog/schema", "samples/blog/schema/migrations", "samples/blog/schema/migrations/001_initial_schema.rb", "samples/blog/schema/migrations/002_add_comments.rb", "samples/blog/schema/migrations/templates", "samples/blog/schema/migrations/templates/empty.rb.erb", "samples/blog/startup.rb", "samples/blog/templates", "samples/blog/templates/comment", "samples/blog/templates/comment/add.mab", "samples/blog/templates/comment/list.mab", "samples/blog/templates/entry", "samples/blog/templates/entry/edit.mab", "samples/blog/templates/entry/list.mab", "samples/blog/templates/entry/show.mab", "samples/blog/templates/entry/summary.mab", "samples/blog/templates/errors", "samples/blog/templates/errors/not_found_404.mab", "samples/blog/templates/errors/server_error_500.mab", "samples/blog/templates/layouts", "samples/blog/templates/layouts/default.mab", "samples/blog/templates/waves", "samples/blog/templates/waves/status.mab", "samples/blog/tmp", "samples/blog/tmp/sessions", "templates/classic", "templates/classic/configurations", "templates/classic/configurations/default.rb.erb", "templates/classic/configurations/development.rb.erb", "templates/classic/configurations/production.rb.erb", "templates/classic/controllers", "templates/classic/helpers", "templates/classic/lib", "templates/classic/lib/application.rb.erb", "templates/classic/lib/tasks", "templates/classic/models", "templates/classic/public", "templates/classic/public/css", "templates/classic/public/flash", "templates/classic/public/images", "templates/classic/public/javascript", "templates/classic/Rakefile", "templates/classic/resources", "templates/classic/resources/map.rb.erb", "templates/classic/schema", "templates/classic/schema/migrations", "templates/classic/startup.rb", "templates/classic/templates", "templates/classic/templates/errors", "templates/classic/templates/errors/not_found_404.mab", "templates/classic/templates/errors/server_error_500.mab", "templates/classic/templates/layouts", "templates/classic/templates/layouts/default.mab", "templates/classic/tmp", "templates/classic/tmp/sessions", "templates/classic/views", "verify/cache", "verify/foundations", "verify/foundations/default_application", "verify/foundations/default_application/bin", "verify/foundations/default_application/configurations", "verify/foundations/default_application/controllers", "verify/foundations/default_application/doc", "verify/foundations/default_application/helpers", "verify/foundations/default_application/lib", "verify/foundations/default_application/lib/tasks", "verify/foundations/default_application/log", "verify/foundations/default_application/models", "verify/foundations/default_application/public", "verify/foundations/default_application/public/css", "verify/foundations/default_application/public/flash", "verify/foundations/default_application/public/images", "verify/foundations/default_application/public/javascript", "verify/foundations/default_application/schema", "verify/foundations/default_application/schema/migrations", "verify/foundations/default_application/schema/migrations/templates", "verify/foundations/default_application/templates", "verify/foundations/default_application/templates/errors", "verify/foundations/default_application/templates/layouts", "verify/foundations/default_application/tmp", "verify/foundations/default_application/tmp/sessions", "verify/foundations/default_application/views", "verify/helpers.rb", "verify/layers", "verify/layers/cache", "verify/layers/cache/file-ipi.rb", "verify/layers/cache/helpers.rb", "verify/layers/helpers.rb", "verify/layers/obsolete_cache", "verify/layers/obsolete_cache/file-ipi.rb", "verify/layers/obsolete_cache/file_cache.rb", "verify/layers/obsolete_cache/helpers.rb", "verify/layers/obsolete_cache/memcached.rb", "verify/layers/sequeltest.db", "verify/matchers", "verify/obsolete_blackboard", "verify/obsolete_mapping", "verify/specs", "verify/specs/app_generation", "verify/specs/app_generation/helpers.rb", "verify/specs/app_generation/startup.rb", "verify/specs/caches", "verify/specs/caches/helpers.rb", "verify/specs/configurations", "verify/specs/configurations/attributes.rb", "verify/specs/configurations/helpers.rb", "verify/specs/configurations/rack_integration.rb", "verify/specs/foundations", "verify/specs/foundations/compact.rb", "verify/specs/foundations/helpers.rb", "verify/specs/layers", "verify/specs/layers/data_mapper", "verify/specs/layers/data_mapper/track_feature.rb", "verify/specs/layers/default_errors.rb", "verify/specs/layers/helpers.rb", "verify/specs/layers/migration.rb", "verify/specs/layers/sequel", "verify/specs/layers/sequel/model.rb", "verify/tests", "verify/tests/caches", "verify/tests/caches/file.rb", "verify/tests/caches/helpers.rb", "verify/tests/caches/simple.rb", "verify/tests/controllers", "verify/tests/controllers/helpers.rb", "verify/tests/controllers/interface.rb", "verify/tests/core", "verify/tests/core/helpers.rb", "verify/tests/core/response_mixin.rb", "verify/tests/core/runtime.rb", "verify/tests/core/track_feature.rb", "verify/tests/core/utilities.rb", "verify/tests/matchers", "verify/tests/matchers/helpers.rb", "verify/tests/matchers/path.rb", "verify/tests/obsolete_mapping", "verify/tests/obsolete_mapping/constraint_matching.rb", "verify/tests/obsolete_mapping/evaluation.rb", "verify/tests/obsolete_mapping/exception_handler.rb", "verify/tests/obsolete_mapping/helpers.rb", "verify/tests/obsolete_mapping/pattern_matching.rb", "verify/tests/obsolete_mapping/query_params.rb", "verify/tests/obsolete_mapping/story.txt", "verify/tests/obsolete_mapping/wrappers.rb", "verify/tests/obsolete_views", "verify/tests/obsolete_views/helpers.rb", "verify/tests/obsolete_views/rendering.rb", "verify/tests/obsolete_views/templates", "verify/tests/obsolete_views/templates/foo.erb", "verify/tests/obsolete_views/templates/moo.erb", "verify/tests/obsolete_views/templates/moo.mab", "verify/tests/requests", "verify/tests/requests/accept.rb", "verify/tests/requests/helpers.rb", "verify/tests/requests/request.rb", "verify/tests/requests/response.rb", "verify/tests/requests/session.rb", "bin/waves"]
  s.has_rdoc = true
  s.homepage = %q{http://rubywaves.com}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{waves}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Open-source framework for building Ruby-based Web applications.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<rakegen>, [">= 0.6.6"])
      s.add_runtime_dependency(%q<autocode>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<rack-cache>, [">= 0.2.0"])
      s.add_runtime_dependency(%q<rack>, [">= 0.4.0"])
      s.add_runtime_dependency(%q<filebase>, [">= 0.3.4"])
      s.add_runtime_dependency(%q<english>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<extensions>, [">= 0.6.0"])
      s.add_runtime_dependency(%q<RedCloth>, [">= 4.0.0"])
      s.add_runtime_dependency(%q<live_console>, [">= 0.2.0"])
      s.add_runtime_dependency(%q<functor>, [">= 0.5.0"])
    else
      s.add_dependency(%q<rakegen>, [">= 0.6.6"])
      s.add_dependency(%q<autocode>, [">= 1.0.0"])
      s.add_dependency(%q<rack-cache>, [">= 0.2.0"])
      s.add_dependency(%q<rack>, [">= 0.4.0"])
      s.add_dependency(%q<filebase>, [">= 0.3.4"])
      s.add_dependency(%q<english>, [">= 0.3.0"])
      s.add_dependency(%q<extensions>, [">= 0.6.0"])
      s.add_dependency(%q<RedCloth>, [">= 4.0.0"])
      s.add_dependency(%q<live_console>, [">= 0.2.0"])
      s.add_dependency(%q<functor>, [">= 0.5.0"])
    end
  else
    s.add_dependency(%q<rakegen>, [">= 0.6.6"])
    s.add_dependency(%q<autocode>, [">= 1.0.0"])
    s.add_dependency(%q<rack-cache>, [">= 0.2.0"])
    s.add_dependency(%q<rack>, [">= 0.4.0"])
    s.add_dependency(%q<filebase>, [">= 0.3.4"])
    s.add_dependency(%q<english>, [">= 0.3.0"])
    s.add_dependency(%q<extensions>, [">= 0.6.0"])
    s.add_dependency(%q<RedCloth>, [">= 4.0.0"])
    s.add_dependency(%q<live_console>, [">= 0.2.0"])
    s.add_dependency(%q<functor>, [">= 0.5.0"])
  end
end

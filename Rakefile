begin
  $: << 'lib'; %w( rubygems rake/testtask rake/rdoctask rake/gempackagetask extensions/all
    utilities/string utilities/symbol date).each { |dep| require dep }
rescue
  puts "Better do `rake setup` to get all the fancies you're missing"
end

gem = Gem::Specification.new do |gem|
  gem.name = "waves"
  gem.summary = "Open-source framework for building Ruby-based Web applications."
  gem.version = '0.7.3'
  gem.homepage = 'http://dev.zeraweb.com/waves'
  gem.author = 'Dan Yoder'
  gem.email = 'dan@zeraweb.com'
  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.8.6'
  %w( mongrel rack markaby erubis RedCloth autocode sequel sqlite3-ruby
      extensions live_console choice daemons bacon flexmock rakegen).each do |dep|
    gem.add_dependency dep
  end
  gem.files = Dir['lib/**/*.rb','app/**/*']
  gem.has_rdoc = true
  gem.bindir = 'bin'
  gem.executables = [ 'waves', 'waves-server', 'waves-console' ]
end

desc "Create the waves gem"
task( :package => :clean ) { Gem::Builder.new( gem ).build }

desc "Clean build artifacts"
task( :clean ) { FileUtils.rm_rf Dir['*.gem'] }

desc "Rebuild and Install Waves as a gem"
task( :install => [ :package, :rdoc, :install_gem ] )

desc "Install Waves a local gem"
task( :install_gem ) do
    require 'rubygems/installer'
    Dir['*.gem'].each do |gem|
  Gem::Installer.new(gem).install
    end
end

desc "create .gemspec file (useful for github)"
task :gemspec do
  filename = "#{gem.name}.gemspec"
  File.open(filename, "w") do |f|
    f.puts gem.to_ruby
  end
end

desc "Publish to RubyForge"
task( :publish => [ :package, :rdoc_publish ] ) do
  `rubyforge login`
  `rubyforge add_release #{gem.name} #{gem.name} #{gem.version} #{gem.name}-#{gem.version}.gem`
end

task( :rdoc_publish => :rdoc ) do
  path = "/var/www/gforge-projects/#{gem.name}/"
  `rsync -a --delete ./doc/rdoc/ dyoder67@rubyforge.org:#{path}`
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'; rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.add [ 'lib/**/*.rb', 'doc/README', 'doc/HISTORY' ]
end

desc "Set up dependencies so you can work from source"
task( :setup ) do
  gems = Gem::SourceIndex.from_installed_gems
  # Runtime dependencies from the Gem's spec.
  dependencies = gem.dependencies
  # Add build-time dependencies, like this:
  dependencies.each do |dep|
    if gems.search(dep.name, dep.version_requirements).empty?
      puts "Installing dependency: #{dep}"
      begin
        require 'rubygems/dependency_installer'
        if Gem::RubyGemsVersion =~ /^1\.0\./
          Gem::DependencyInstaller.new(dep.name, dep.version_requirements).install
        else
          # as of 1.1.0
          Gem::DependencyInstaller.new.install(dep.name, dep.version_requirements)
        end
      rescue LoadError # < rubygems 1.0.1
        require 'rubygems/remote_installer'
        Gem::RemoteInstaller.new.install(dep.name, dep.version_requirements)
      end
    end
  end
  system(cmd = "chmod +x bin/waves*")
end

desc "Run verification suite."
Rake::TestTask.new(:verify) do |t|
  t.test_files = FileList["verify/**/*.rb"].exclude(
  "**/helpers.rb",
  "**/foundations/*_application/**/*", 
  "**/app_generation/*.rb")
  t.verbose = true
end

namespace :verify do
  
  FileList["verify/*/"].each do |area|
    task = area.chomp("/").sub("verify/", '')
    Rake::TestTask.new(task) do |t|
      t.test_files = FileList["#{area}**/*.rb"].exclude("**/helpers.rb")
      t.verbose = true
    end
  end

end



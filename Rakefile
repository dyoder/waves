require 'rubygems'
require 'rake/rdoctask'
require 'rake/gempackagetask'

gem = Gem::Specification.new do |gem|
	gem.name = "waves"
	gem.summary	= "Open-source framework for building Ruby-based Web applications."
	gem.version = '0.7.1'
	gem.homepage = 'http://dev.zeraweb.com/waves'
	gem.author = 'Dan Yoder'
	gem.email = 'dan@zeraweb.com'
	gem.platform = Gem::Platform::RUBY
	gem.required_ruby_version = '>= 1.8.6'
	%w( mongrel rack markaby erubis redcloth autocode sequel 
	    extensions live_console choice daemons ).each do |dep|
	  gem.add_dependency dep
	end
	gem.files = Dir['lib/**/*.rb','app/**/*']
	gem.has_rdoc = true
	gem.bindir = 'bin'
	gem.executables = [ 'waves', 'waves-server', 'waves-console' ]
end

task( :package => :clean ) { Gem::Builder.new( gem ).build } 
task( :clean ) { `rm -rf *.gem` }
task( :install => [ :package, :rdoc ] ) { `sudo gem install *.gem` }
task( :publish => [ :package, :rdoc_publish ] ) do
  `rubyforge login`
  `rubyforge add_release #{gem.name} #{gem.name} #{gem.version} #{gem.name}-#{gem.version}.gem`
end

task( :sync ) do
  options = '-a --delete'
  exclude = [ '*.old', '*.gem', '.svn', 'pkg' ].map { |pat| "--exclude=#{pat}" }.join(' ')
  path = "~/Repositories/#{gem.name}/"
   `rsync #{options} #{exclude} ./ #{path}`
end

task( :rdoc_publish => :rdoc ) do
  path = "/var/www/gforge-projects/#{gem.name}/"
  `rsync -a --delete ./doc/rdoc/ dyoder67@rubyforge.org:#{path}`
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'; rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.add [ 'lib/**/*.rb', 'doc/README', 'doc/HISTORY' ]
end

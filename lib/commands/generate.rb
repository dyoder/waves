require 'choice'
require 'rakegen'

Choice.options do
  banner 'Usage:  waves path/to/app [-h]'
  option :help  do
    long '--help'
    desc 'Show this message'
  end
  
  option :orm do
    short '-o'
    long '--orm=ORM'
    desc "Select an ORM (e.g. active_record, sequel, none)"
    default "sequel"
  end
  
  option :template do
    short '-t'
    long '--template=FOUNDATION'
    desc "Select a template for app generation (Built-in options: 'classic', 'compact')."
    default "classic"
  end
  
end

puts "** Waves #{File.read("#{WAVES}/doc/VERSION")}"

available_orms = [ 'sequel' ,  'active_record' , 'none' ]
orm = Choice.choices.orm.snake_case
orm_require, orm_include = case orm
when 'sequel'
  ["require 'layers/orm/sequel'", "include Waves::Layers::ORM::Sequel"]
when /active([-_]*)record/
  ["require 'layers/orm/active_record'", "include Waves::Layers::ORM::ActiveRecord"]
when 'none'
  ['', '# This app was generated without an ORM layer.']
else
  puts "I'm sorry, '#{orm}' is not listed as an available option.\nTry: \t"
  available_orms.each { |x| puts "\t\t#{x}" }
  raise ArgumentError
end

app_path = ARGV[0]
app_name = File.basename(app_path)
if app_name =~ /[^\w\d_]/
  raise ArgumentError, <<-TEXT
  Unusable name: \"#{app_name}\"
  Application names may contain only letters, numbers, and underscores."
TEXT
end

skip_rake = false
use_builtin = File.exist?(Choice.choices.template) ? false : true

if use_builtin
  case Choice.choices.template
  when ('classic' and use_builtin == true)
    template = "#{WAVES}/app/classic"
  when 'compact'
    compact_app = <<-COMPACT
  require 'foundations/compact'

  module #{app_name}
    include Waves::Foundations::Compact

    module Resources
      class Map
      end

    end
  end
  COMPACT
    skip_rake = true
    File.open(app_path / app_name + '.rb', 'w') {|file| file.print compact_app}
  end
else
  template = Choice.choices.template
end

unless skip_rake 
  generator = Rakegen.new("waves:app") do |gen|
    gen.source = template
    gen.target = app_path
    gen.template_assigns = {:name => app_name.camel_case, :orm_require => orm_require, :orm_include => orm_include }
  end
end

puts "** Creating new Waves application ..."

Rake::Task["waves:app"].invoke unless skip_rake

puts "** Application created!"
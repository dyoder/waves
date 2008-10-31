require 'choice'
require 'rakegen'

waves = File.expand_path( File.dirname( __FILE__ ) / '..' / '..' )
orms = Dir[ waves / :lib / :layers / :orm / :providers / '*.rb' ].map { |path| File.basename( path, '.rb' )}
templates = Dir[ waves / :templates / '*' ].map { |path| File.basename( path ) }

Choice.options do
  
  option :help  do
    long '--help'
    desc 'Show this message'
  end
  
  option :orm do
    short '-o'
    long '--orm=ORM'
    desc "Select an ORM (currently supported: #{orms * ', '} )"
    valid orms
  end

  option :template do
    short '-t'
    long '--template=classic'
    desc "Select a template for your app (options: #{templates * ', '})."
    valid templates
  end

  option :name, :required => true do
    short '-n'
    long '--name'
    desc "Select a name for the application. Use only letters, numbers, dashes, or underscores."
    validate /^[\w\d\-]+$/
  end

end

options = Choice.choices

puts "** Creating new Waves application ..."

# why do i have to do this?
FileUtils.mkdir( File.expand_path( options.name ) )
generator = Rakegen.new("generate") do |gen|
  gen.source = waves / :templates / options.template
  gen.target = File.expand_path( options.name )
  gen.template_assigns = options.merge( :name => options.name.gsub('-','_').camel_case )
end.invoke

puts "** Application created!"
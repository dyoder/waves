%w( rubygems bacon open3 extensions/all).each { |f| require f }

Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit

require File.join(File.dirname(__FILE__), "..", "..", "lib", "utilities", "string")


AppPath = File.expand_path(File.dirname(__FILE__) / "sandbox")
FrameworkPath = File.expand_path(File.dirname(__FILE__) / ".." / "..")

def generate_test_app(path)
  command = File.dirname(__FILE__) / ".." / ".." / :bin / "waves"
  system "#{command} #{path}"
end

def clobber_test_app(path)
  FileUtils.rm_rf(path) if File.exist?(path)
end

def set_framework_path(path)
  text = File.read(path / 'startup.rb').split("\n").unshift("WAVES = '#{FrameworkPath}'").join("\n")
  File.write(path / 'startup.rb', text)
end

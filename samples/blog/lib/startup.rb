Gem.clear_paths
Gem.path.unshift(Waves::Configurations::Default.root / "gems")

require 'lib/blog'
Waves << Blog
Application = Blog
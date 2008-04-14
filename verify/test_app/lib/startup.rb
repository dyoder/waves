Gem.clear_paths
Gem.path.unshift(Waves::Configurations::Default.root / "gems")

require Waves::Configurations::Default.root / "lib" / "test_app"
Waves << TestApp
Application = TestApp
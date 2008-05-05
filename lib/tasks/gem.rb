namespace :gem do
  desc "freeze a gem using gem=<gem name> [version=<gem version>]"
  task :freeze do
    raise "No gem specified" unless gem_name = ENV['gem']

    require 'rubygems'
    Gem.manage_gems

    gem = (version = ENV['version']) ?
      Gem.cache.search(gem_name, "= #{version}").first :
      Gem.cache.search(gem_name).sort_by { |g| g.version }.last

    version ||= gem.version.version rescue nil

    target_dir = File.join(Waves::Configurations::Default.root, 'gems')
    mkdir_p target_dir
    sh "gem install #{gem_name} --version #{version} -i #{target_dir} --no-rdoc --no-ri"

    puts "Unpacked #{gem_name} #{version} to '#{target_dir}'"
  end

  desc "unfreeze a gem using gem=<gem>"
  task :unfreeze do
    raise "No gem specified" unless gem_name = ENV['gem']

    target_dir = File.join(Waves::Configurations::Default.root, 'gems')
    ENV['GEM_HOME'] = target_dir # no install_dir option for gem uninstall

    sh "gem uninstall #{gem_name}"
  end
end

namespace :manager do

  desc 'Start a cluster of waves applications.'
  task :start do |task|
    File.write('pid', Manager.run( :daemonize => true ) )
  end

  desc 'Stop a cluster of waves applications.'
  task :stop do |task|
    Process.kill( 'INT', File.read( 'pid' ) ) rescue nil
  end

  desc 'Restart a cluster of waves applications.'
  task :restart do |task|
    Process.kill( 'HUP', File.read( 'pid' ) ) rescue nil
  end

end

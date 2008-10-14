namespace :manager do

  desc 'Start a cluster of waves applications.'
  task :start do |task|
    File.write('.pid', Waves::Manager.run( :daemon => true, :mode => ENV['config'] ) )
  end

  desc 'Stop a cluster of waves applications.'
  task :stop do |task|
    Process.kill( 'INT', File.read( '.pid' ).to_i )
  end

  desc 'Restart a cluster of waves applications.'
  task :restart do |task|
    Process.kill( 'HUP', File.read( '.pid' ).to_i )
  end

end

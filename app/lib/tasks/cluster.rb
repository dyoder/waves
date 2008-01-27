namespace :cluster do

	desc 'Start a cluster of waves applications.'
  task :start => :stop do |task|
    pids = []; path = :log / :pids
    Waves::Console.config.ports.each do |port|
      pid = fork { exec "waves_server -p #{port} #{ENV['mode']} -d" }
      Process.detach( pid ); pids << pid
    end
    File.write( path, pids.join(',') )
	end
	
	desc 'Stop a cluster of waves applications.'
	task :stop do |task|
	  path = :log / :pids
	  if File.exist? path
  	  File.read( path ).split(',').each { |pid| Process.kill( 'INT', pid.to_i ) rescue nil }
  	  FileUtils.rm( path )
  	end
	end
	
	desc 'Restart a cluster of waves applications.'
	task :restart => [ :stop, :start ] do |task|
	end
	
end

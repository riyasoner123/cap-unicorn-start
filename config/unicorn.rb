# Set the working application directory
working_directory "/home/ubox/PROJECT/cap-uni-autorestart/testunicorn"

# Define the directory path for the UNIX socket file
socket_directory = '/home/ubox/PROJECT/cap-uni-autorestart/testunicorn/tmp/sockets'

# Ensure the directory exists for the socket file
Dir.mkdir(socket_directory) unless File.directory?(socket_directory)

# Set the path to the Unicorn PID file
pid '/home/ubox/PROJECT/demoapp/tmp/pids/unicorn.pid'

# Path to logs (uncomment and adjust paths if needed)
stderr_path "/home/ubox/PROJECT/cap-uni-autorestart/testunicorn/log/unicorn.stderr.log"
stdout_path "/home/ubox/PROJECT/cap-uni-autorestart/testunicorn/log/unicorn.stdout.log"


# Define the Unicorn socket
listen "#{socket_directory}/unicorn.sock", backlog: 64

# Alternatively, you can use a TCP socket:
listen "127.0.0.1:3000"

# Number of worker processes
worker_processes 2

# Time-out for worker processes
timeout 30

# Preload the application before forking worker processes
preload_app true

# Code to run before forking worker processes
before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

# Code to run after forking worker processes
after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end



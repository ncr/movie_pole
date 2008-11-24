require 'active_support'
require 'fileutils'
require 'action_controller/vendor/rack'
require 'optparse'

# TODO: Push Thin adapter upstream so we don't need worry about requiring it
begin
  require_library_or_gem 'thin'
rescue Exception
  # Thin not available
end

options = {
  :Port        => 3000,
  :Host        => "0.0.0.0",
  :environment => (ENV['RAILS_ENV'] || "development").dup,
  :config      => RAILS_ROOT + "/config.ru",
  :detach      => false,
  :debugger    => false
}

ARGV.clone.options do |opts|
  opts.on("-p", "--port=port", Integer,
          "Runs Rails on the specified port.", "Default: 3000") { |v| options[:Port] = v }
  opts.on("-b", "--binding=ip", String,
          "Binds Rails to the specified ip.", "Default: 0.0.0.0") { |v| options[:Host] = v }
  opts.on("-c", "--config=file", String,
          "Use custom rackup configuration file") { |v| options[:config] = v }
  opts.on("-d", "--daemon", "Make server run as a Daemon.") { options[:detach] = true }
  opts.on("-u", "--debugger", "Enable ruby-debugging for the server.") { options[:debugger] = true }
  opts.on("-e", "--environment=name", String,
          "Specifies the environment to run this server under (test/development/production).",
          "Default: development") { |v| options[:environment] = v }

  opts.separator ""

  opts.on("-h", "--help", "Show this help message.") { puts opts; exit }

  opts.parse!
end

server = Rack::Handler.get(ARGV.first) rescue nil
unless server
  begin
    server = Rack::Handler::Mongrel
  rescue LoadError => e
    server = Rack::Handler::WEBrick
  end
end

puts "=> Booting #{ActiveSupport::Inflector.demodulize(server)}"
puts "=> Rails #{Rails.version} application starting on http://#{options[:Host]}:#{options[:Port]}"

%w(cache pids sessions sockets).each do |dir_to_make|
  FileUtils.mkdir_p(File.join(RAILS_ROOT, 'tmp', dir_to_make))
end

if options[:detach]
  Process.daemon
  pid = "#{RAILS_ROOT}/tmp/pids/server.pid"
  File.open(pid, 'w'){ |f| f.write(Process.pid) }
  at_exit { File.delete(pid) if File.exist?(pid) }
end

ENV["RAILS_ENV"] = options[:environment]
RAILS_ENV.replace(options[:environment]) if defined?(RAILS_ENV)
require RAILS_ROOT + "/config/environment"

if File.exist?(options[:config])
  config = options[:config]
  if config =~ /\.ru$/
    cfgfile = File.read(config)
    if cfgfile[/^#\\(.*)/]
      opts.parse!($1.split(/\s+/))
    end
    app = eval("Rack::Builder.new {( " + cfgfile + "\n )}.to_app", nil, config)
  else
    require config
    app = Object.const_get(File.basename(config, '.rb').capitalize)
  end
else
  app = Rack::Builder.new {
    use Rails::Rack::Logger
    use Rails::Rack::Static
    run ActionController::Dispatcher.new
  }.to_app
end

if options[:debugger]
  begin
    require_library_or_gem 'ruby-debug'
    Debugger.start
    Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
    puts "=> Debugger enabled"
  rescue Exception
    puts "You need to install ruby-debug to run the server in debugging mode. With gems, use 'gem install ruby-debug'"
    exit
  end
end

puts "=> Call with -d to detach"

trap(:INT) { exit }

puts "=> Ctrl-C to shutdown server"

begin
  server.run(app, options.merge(:AccessLog => []))
ensure
  puts 'Exiting'
end

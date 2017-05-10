require 'optparse'

options = {}
parser = OptionParser.new do |opts|
    opts.banner = 'Usage: hc-server [options] command'

    opts.on('-t', '--target', 'Target infrastructure path. Defaults to CWD.') { |v| options[:target_path] = v || Dir.pwd }
end
parser.parse!

command = ARGV.pop
if command.nil? then
    puts 'Command is a required parameter'
    puts parser.to_s
    exit
end

puts "Target: #{options[:target_path]}"
puts "Command: #{command}"

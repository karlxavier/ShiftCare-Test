require 'optparse'
require 'json'

class JsonSearcher
  OPT_KEYS = %i(
    file
    search_key
    search_value
    search_duplicates
  )

  def initialize(options)
    self.options = options
  end

  OPT_KEYS.each do |key|
    define_method(key.to_sym) do
      options[key]
    end
  end

  def results
    return searches unless search_key.nil?
    return duplicates unless search_duplicates.nil?
  end

  def searches
    datasets = clients.select do |client|
      client = OpenStruct.new(client)

      client.send(search_key).to_s.include?(search_value)
    end 
    
    datasets.empty? ? "No matching records found." : datasets
  end

  def duplicates
    client_groups = clients.group_by { |client| client[search_duplicates] }
    datasets = client_groups.select { |key, group| group.length > 1 }.values.flatten
    
    datasets.empty? ? "No duplicate records found." : datasets
  end

  private

  attr_accessor :options

  def clients
    @clients ||= begin
      load_data(options[:file])
    end
  end

  def load_data(file_path)
    JSON.parse(File.read(file_path))
  rescue StandardError => e
    puts "Error loading JSON file: #{e.message}"
    exit
  end
end

options = {}
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby app.rb [options]"

  opts.on("-f", "--file FILE", "Path to JSON file") do |file|
    options[:file] = file
  end

  opts.on("-s", "--search-key KEY", "Key to search on in the JSON") do |key|
    options[:search_key] = key
  end

  opts.on("-v", "--search-value VALUE", "Value to search for in the JSON") do |value|
    options[:search_value] = value
  end

  opts.on("-d", "--search-duplicates VALUE", "Search for ") do |value|
    options[:search_duplicates] = value
  end

  opts.on("-h", "--help", "Show this help message") do
    puts opts
    exit
  end
end

begin
  opt_parser.parse!

  raise OptionParser::MissingArgument if options[:file].nil? || (
    (options[:search_value].nil? || options[:search_key].nil?) && options[:search_duplicates].nil?
  )
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts opt_parser
  exit
end

searcher = JsonSearcher.new(options)
results = searcher.results

puts "Results: #{results.size}"
puts results.is_a?(String) ? results : JSON.pretty_generate(JSON.parse(results.to_json))


# ruby search.rb -f clients.json -s "id" -v 1
# ruby search.rb -f clients.json -d "full_name"

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Picks the minimum number of postal codes from a list of postal codes so that the picked postal codes cover all riding IDs contained in the list"
task :trim_postal_codes do |t,args|
  abort "Usage: rake trim_postal_codes file=<filename> [verbose=1]" unless args[:file]
  require File.expand_path('../lib/gov_kit-ca', __FILE__)

  postal_to_rid = {}
  File.read(args[:file]).split("\n").uniq.each do |postal_code| # Remove duplicate postal codes
    begin
      postal_to_rid[postal_code] = GovKit::CA::PostalCode::Strategy::CbcCa.new(postal_code).json_response.map{|hash| hash['rid'].to_i}
    rescue JSON::ParserError => e # Ignore invalid postal codes
      puts "#{postal_code} is invalid" if args[:verbose]
    end
  end

  # Get the minimum number of postal codes to cover all riding IDs. This is an
  # instance of the set cover problem, which is NP-complete. We use the greedy
  # algorithm, which is the best-possible polynomial time approximation
  # algorithm for set cover. http://en.wikipedia.org/wiki/Set_cover_problem
  postal_codes = []
  while postal_to_rid.size.nonzero?
    postal_code, rids = postal_to_rid.find{|k,v| v.size == postal_to_rid.map{|k,v| v.size}.max}
    postal_to_rid.each{|k,v| postal_to_rid[k] -= rids}
    postal_to_rid.reject!{|k,v| v.empty?}
    postal_codes << postal_code
  end

  puts postal_codes
end

desc "Generates YAML mapping cbc.ca's riding ID's to electoral districts"
task :cbc_riding_id do |t,args|
  require 'csv'
  require 'open-uri'
  require File.expand_path('../lib/gov_kit-ca', __FILE__)

  def transliterate(string)
    {
      # elections.ca
      /\342\200\223/   => '-',
      /\303\242/       => 'a',
      /\303[\251\250]/ => 'e',
      /\303\264/       => 'o',
      /\303\211/       => 'E',
      /\303\216/       => 'I',
      # cbc.ca
      / - /            => '-',
      /\342/           => 'a',
      /[\350\351]/     => 'e',
      /\364/           => 'o',
      /\311/           => 'E',
      /\316/           => 'I',
    }.reduce(string) do |string,map|
      string.gsub(map[0], map[1])
    end
  end

  # Map electoral district names to electoral district IDs
  name_to_edid = {}
  doc = Nokogiri::HTML(open("http://www.elections.ca/content.aspx?section=res&dir=cir/list&document=index&lang=e").read)
  doc.css('sup').remove
  edids = doc.css('table[summary^="List"] th.normal').map{|x| x.text.to_i}
  doc.css('table[summary^="List"] th.normal + td').map{|x| x.text.gsub(/\s+/, ' ').strip}.each_with_index do |name,index|
    name_to_edid[transliterate(name)] = edids[index]
  end

  # Map electoral district names to cbc.ca's riding IDs
  name_to_rid = {}
  CSV.foreach(args.first) do |row|
    GovKit::CA::PostalCode::Strategy::CbcCa.new(row[0]).json_response.each do |hash|
      name_to_rid[transliterate(hash['name'])] = hash['rid'].to_i
    end
  end
end
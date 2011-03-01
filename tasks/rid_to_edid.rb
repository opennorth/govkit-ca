require 'csv'
require 'open-uri'
require File.expand_path('../../lib/gov_kit-ca', __FILE__)

# http://www.digital-copyright.ca/pcfrf/pcfrf.tgz contains
# `postal-code-for-districts.csv`, "which is 308 postal codes that should
# map to each of the 308 different electoral districts." However, six of the
# postal codes are invalid (G0A2C0, J8M1R8, J0W1B0, J0B1H0, L0J1B0, N2A1A3),
# 14 are duplicate, and the remaining 294 map to 246 electoral districts.
desc "Picks the set cover for postal codes to cbc.ca riding IDs"
task :trim_postal_codes do |t,args|
  abort "Usage: rake #{t.name} file=postal-codes-for-districts.csv" unless args[:file]

  # Get the riding IDs that each postal code covers
  postal_to_rid = {}
  File.read(args[:file]).split("\n").uniq.each do |postal_code| # Remove duplicate postal codes
    begin
      postal_to_rid[postal_code] = GovKit::CA::PostalCode::Strategy::CbcCa.new(postal_code).json_response.map{|hash| hash['rid'].to_i}
    rescue JSON::ParserError => e # Ignore invalid postal codes
      puts "ERROR: #{postal_code} is invalid"
    end
  end

  # Get the minimum number of postal codes to cover all riding IDs. This is an
  # instance of the set cover problem, which is NP-complete. We use the greedy
  # algorithm, which is the best-possible polynomial time approximation
  # algorithm for set cover. http://en.wikipedia.org/wiki/Set_cover_problem
  postal_codes = []
  until postal_to_rid.empty?
    postal_code, rids = postal_to_rid.find{|k,v| v.size == postal_to_rid.map{|k,v| v.size}.max}
    postal_to_rid.each{|k,v| postal_to_rid[k] -= rids}
    postal_to_rid.reject!{|k,v| v.empty?}
    postal_codes << postal_code
  end

  puts postal_codes.sort
end

# Use https://github.com/danielharan/pc_scraper/raw/master/data/index.csv and
# https://github.com/danielharan/canadian-postal-code-to-electoral-districts/raw/master/pc_edid.yml
# The YAML file may contain invalid postal codes, e.g. M5V1L6, and does not
# contain every electoral district, e.g. 35061. 35061 corresponds to riding ID
# 168, which contains the postal code L1H1X8.
desc "Generates postal codes within the given list of cbc.ca riding IDs"
task :riding_id_to_postal_code do |t,args|
  abort "Usage: rake #{t.name} file=riding-ids.csv csv=index.csv yml=pc_edid.yml" unless args[:file] && args[:csv] && args[:yml]

  # The YML file maps postal codes to electoral districts
  yml = YAML.load_file(args[:yml])

  # Get an old map of riding IDs to electoral districts
  rid_to_edid = {}
  CSV.foreach(args[:csv]) do |row|
    rid_to_edid[row[1]] = row[0]
  end

  # Map riding IDs to postal codes
  rid_to_postal = {}
  File.read(args[:file]).split("\n").each do |riding_id|
    match = yml.find{|k,v| v == rid_to_edid[riding_id]}
    if match
      rid_to_postal[riding_id] = match[0]
    else
      puts "ERROR: No postal code for riding ID #{riding_id}, electoral district #{rid_to_edid[riding_id]}"
    end
  end

  puts rid_to_postal.values.sort
end

# Pass postal-code-for-districts.csv from http://www.digital-copyright.ca/pcfrf/pcfrf.tgz
# through `rake trim_postal_codes`. This rake task will print a list of riding
# IDs which none of the given postal codes belong to. Pass this list through
# `rake riding_id_to_postal_code` to get a list of postal codes belonging to
# those riding IDs. Manually add postal codes for any remaining riding IDs.
desc "Generates YAML mapping cbc.ca riding IDs to electoral districts"
task :riding_id_to_electoral_district do |t,args|
  abort "Usage: rake #{t.name} file=postal-codes-for-districts.csv" unless args[:file]

  def transliterate_elections_ca(string)
    {
      /\342\200\223/   => '-',
      /\303\242/       => 'a',
      /\303[\251\250]/ => 'e',
      /\303\264/       => 'o',
      /\303\211/       => 'E',
      /\303\216/       => 'I',
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
    name_to_edid[transliterate_elections_ca(name)] = edids[index]
  end

  def transliterate_cbc_ca(string)
    {
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

  # Map electoral district names to riding IDs
  name_to_rid = {}
  File.read(args[:file]).split("\n").each do |postal_code|
    GovKit::CA::PostalCode::Strategy::CbcCa.new(postal_code).json_response.each do |hash|
      name_to_rid[transliterate_cbc_ca(hash['name'])] = hash['rid'].to_i
    end
  end

  # Can we generate a complete mapping?
  missing = name_to_edid.keys - name_to_rid.keys
  unless missing.empty?
    abort "The postal codes in #{args[:file]} do not cover #{missing.size} electoral districts:\n#{missing.sort.join("\n")}\n\nThe missing cbc.ca riding IDs are:\n#{([*1..308] - name_to_rid.map{|k,v| v}.flatten).sort.join("\n")}"
  end

  # Map riding IDs to electoral districts
  rid_to_edid = {}
  name_to_edid.keys.each do |name|
    rid_to_edid[name_to_rid[name]] = name_to_edid[name]
  end

  puts rid_to_edid.to_yaml
end

require File.expand_path('../../lib/gov_kit-ca', __FILE__)

desc "Picks the set cover for postal codes to electoral districts"
task :set_cover, :file do |t,args|
  abort "Usage: rake #{t.name}[postal-code-for-districts.csv]" unless args[:file]

  # Get the electoral districts that each postal code covers
  postal_to_edid = {}
  File.read(args[:file]).split("\n").uniq.each do |postal_code| # Remove duplicate postal codes
    postal_to_edid[postal_code] = GovKit::CA::PostalCode.find_electoral_districts_by_postal_code(postal_code)
  end

  # Report how many electoral districts are covered.
  size = postal_to_edid.values.flatten.uniq.size
  if size < 308
    puts "Postal codes cover #{size} electoral districts."
  end

  # Get the minimum number of postal codes to cover the electoral districts.
  # This is an instance of the set cover problem, which is NP-complete. Use the
  # greedy algorithm, which is the best-possible polynomial time approximation
  # algorithm for set cover. https://en.wikipedia.org/wiki/Set_cover_problem
  postal_codes = []
  until postal_to_edid.empty?
    postal_code, edids = postal_to_edid.max{|_,v| v.size}
    postal_to_edid.each{|k,v| postal_to_edid[k] -= edids}
    postal_to_edid.reject!{|k,v| v.empty?}
    postal_codes << postal_code
  end

  puts postal_codes.sort
end

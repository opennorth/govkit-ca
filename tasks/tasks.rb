require File.expand_path('../../lib/gov_kit-ca', __FILE__)

# The following file maps 629,605 postal codes to electoral districts:
# https://github.com/danielharan/canadian-postal-code-to-electoral-districts/raw/master/pc_edid.yml
# However, it contains invalid postal codes, such as M5V1L6, and doesn't contain
# every electoral district, such as 35061 (postal code L1H1X8).
#
# http://www.digital-copyright.ca/pcfrf/pcfrf.tgz contains
# postal-code-for-districts.csv, "which is 308 postal codes that should map to
# each of the 308 different electoral districts." However, six of them do not
# exist (G0A2C0, J8M1R8, J0W1B0, J0B1H0, L0J1B0, N2A1A3), 14 are duplicate, and
# the remaining 294 map to 246 electoral districts.
#
# The included tasks/postal-code-for-districts.csv covers 275 electoral
# districts at the time of writing.
desc "Picks the set cover for postal codes to electoral districts"
task :trim_postal_codes, :file do |t,args|
  abort "Usage: rake #{t.name}[postal-code-for-districts.csv]" unless args[:file]

  # Get the electoral districts that each postal code covers
  postal_to_edid = {}
  File.read(args[:file]).split("\n").uniq.each do |postal_code| # Remove duplicate postal codes
    postal_to_edid[postal_code] = GovKit::CA::PostalCode.find_electoral_districts_by_postal_code(postal_code)
  end

  size = postal_to_edid.values.flatten.uniq.size
  if size < 308
    puts "Postal codes cover #{size} of 308 electoral districts."
  end

  # Get the minimum number of postal codes to cover all electoral districts.
  # This is an instance of the set cover problem, which is NP-complete. Use the
  # greedy algorithm, which is the best-possible polynomial time approximation
  # algorithm for set cover. http://en.wikipedia.org/wiki/Set_cover_problem
  postal_codes = []
  until postal_to_edid.empty?
    postal_code, edids = postal_to_edid.max{|_,v| v.size}
    postal_to_edid.each{|k,v| postal_to_edid[k] -= edids}
    postal_to_edid.reject!{|k,v| v.empty?}
    postal_codes << postal_code
  end

  puts postal_codes.sort
end

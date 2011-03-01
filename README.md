# GovKit-CA

GovKit-CA is a Ruby gem that provides easy access to Canadian civic data around the web. It currently provides an API for free postal code to electoral district lookups, using the following sources:

* [elections.ca](http://elections.ca/)
* [cbc.ca](http://www.cbc.ca/)
* [ndp.ca](http://www.ndp.ca/)
* [digital-copyright.ca](http://www.digital-copyright.ca/)
* [liberal.ca](http://www.liberal.ca/)

GovKit-CA follows from [Participatory Politics Foundation](http://www.participatorypolitics.org/)'s [GovKit](https://github.com/opengovernment/govkit) gem. GovKit-CA is not affiliated with the Participatory Politics Foundation or GovKit.

# Installation

    gem install govkit

# Examples

    >> require 'govkit-ca'

    >> GovKit::CA::PostalCode.find_electoral_districts_by_postal_code('A1A1A1')
    => [10007]
    >> GovKit::CA::PostalCode.find_electoral_districts_by_postal_code('K0A1K0')
    => [35087, 35025, 35052, 35012, 35040, 35063, 35064]

    >> GovKit::CA::PostalCode.find_province_by_postal_code('A1A1A1')
    => "Newfoundland and Labrador"
    >> GovKit::CA::PostalCode.find_province_by_postal_code('K0A1K0')
    => "Ontario"

Postal codes may contain lowercase letters. Spaces and non-alphanumeric characters are removed before processing.

GovKit-CA will raise GovKit::CA::ResourceNotFound if the electoral districts within a postal code cannot be determined.

# Bugs? Questions?

Govkit-CA's main repository is on GitHub: [http://github.com/jpmckinney/govkit-ca](http://github.com/jpmckinney/govkit-ca), where your contributions, forks, bug reports, feature requests, and feedback are greatly welcomed.

# TODOs

* Write tests
* Add a `ElectoralDistrict` class to convert IDs to English and french names.

Copyright (c) 2011 James McKinney, released under the MIT license

# GovKit-CA

[![Build Status](https://secure.travis-ci.org/opennorth/govkit-ca.png)](http://travis-ci.org/opennorth/govkit-ca)
[![Dependency Status](https://gemnasium.com/opennorth/govkit-ca.png)](https://gemnasium.com/opennorth/govkit-ca)
[![Coverage Status](https://coveralls.io/repos/opennorth/govkit-ca/badge.png?branch=master)](https://coveralls.io/r/opennorth/govkit-ca)
[![Code Climate](https://codeclimate.com/github/opennorth/govkit-ca.png)](https://codeclimate.com/github/opennorth/govkit-ca)

GovKit-CA is a Ruby gem that provides easy access to Canadian civic data around the web. It currently provides an API for free postal code to electoral district lookups, using the following sources:

* [elections.ca](http://elections.ca/)
* [cbc.ca](http://www.cbc.ca/)
* [ndp.ca](http://www.ndp.ca/)
* [digital-copyright.ca](http://www.digital-copyright.ca/)
* [liberal.ca](http://www.liberal.ca/)
* [greenparty.ca](http://www.greenparty.ca/)
* [parl.gc.ca](http://www.parl.gc.ca/)
* [conservative.ca](http://www.conservative.ca/)

GovKit-CA follows from [Participatory Politics Foundation](http://www.participatorypolitics.org/)'s [GovKit](https://github.com/opengovernment/govkit) gem. GovKit-CA is not affiliated with the Participatory Politics Foundation or GovKit.

# Installation

    gem install govkit-ca

# Examples

    >> require 'govkit-ca'

    >> GovKit::CA::PostalCode.find_electoral_districts_by_postal_code('A1A1A1')
    => [10007]
    >> GovKit::CA::PostalCode.find_electoral_districts_by_postal_code('K0A1K0')
    => [35012, 35025, 35040, 35052, 35063, 35064, 35087]
    >> GovKit::CA::PostalCode.find_electoral_districts_by_postal_code('H0H0H0')
    => GovKit::CA::ResourceNotFound

    >> GovKit::CA::PostalCode.find_province_by_postal_code('A1A1A1')
    => "Newfoundland and Labrador"
    >> GovKit::CA::PostalCode.find_province_by_postal_code('K0A1K0')
    => "Ontario"
    >> GovKit::CA::PostalCode.find_province_by_postal_code('H0H0H0')
    => "Quebec"

Postal codes may contain lowercase letters. Spaces and non-alphanumeric characters are removed before processing.

GovKit-CA will raise GovKit::CA::ResourceNotFound if the electoral districts within a postal code cannot be determined, and GovKit::CA::InvalidRequest if a postal code is not properly formatted.

# Bugs? Questions?

GovKit-CA interoperates with [Participatory Politics Foundation](http://www.participatorypolitics.org/)'s [GovKit](https://github.com/opengovernment/govkit). Please join the [GovKit Google Group](http://groups.google.com/group/govkit), especially if you'd like to talk about a new feature and get announcements.

This gem's main repository is on GitHub: [http://github.com/opennorth/govkit-ca](http://github.com/opennorth/govkit-ca), where your contributions, forks, bug reports, feature requests, and feedback are greatly welcomed.

Copyright (c) 2011-2013 Open North Inc., released under the MIT license

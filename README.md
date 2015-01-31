# GovKit-CA

[![Gem Version](https://badge.fury.io/rb/govkit-ca.svg)](https://badge.fury.io/rb/govkit-ca)
[![Build Status](https://secure.travis-ci.org/opennorth/govkit-ca.png)](https://travis-ci.org/opennorth/govkit-ca)
[![Dependency Status](https://gemnasium.com/opennorth/govkit-ca.png)](https://gemnasium.com/opennorth/govkit-ca)
[![Coverage Status](https://coveralls.io/repos/opennorth/govkit-ca/badge.png?branch=master)](https://coveralls.io/r/opennorth/govkit-ca)
[![Code Climate](https://codeclimate.com/github/opennorth/govkit-ca.png)](https://codeclimate.com/github/opennorth/govkit-ca)

GovKit-CA is a Ruby gem that provides easy access to Canadian civic information around the web. 

## Installation

    gem install govkit-ca

## Represent API

GovKit-CA provides a [Represent API](https://represent.opennorth.ca/api/) client. First, create a client:

```ruby
require 'govkit-ca'

client = GovKit::CA::Represent.new
```

Send a request to the [`/postcodes` endpoint](https://represent.opennorth.ca/api/#postcode):

```ruby
client.postcodes('A1A1A1')
```

Send a request to the [`/representative-sets` endpoint](https://represent.opennorth.ca/api/#representativeset):

```ruby
client.representative_sets(limit: 0)
```

Send a request to the [`/representatives` endpoint](https://represent.opennorth.ca/api/#representative):

```ruby
client.representatives(representative_set: 'toronto-city-council')
```

Send a request to the [`/boundary-sets` endpoint](https://represent.opennorth.ca/api/#boundaryset):

```ruby
client.boundary_sets(limit: 0)
```

Send a request to the [`/boundaries` endpoint](https://represent.opennorth.ca/api/#boundary):

```ruby
client.boundaries(boundary_set: 'toronto-wards')
```

Read the full documentation on [RubyDoc.info](http://rubydoc.info/gems/govkit-ca/GovKit/CA/Represent).

## Postal code to electoral district lookup

GovKit-CA provides an API for free postal code to electoral district lookups, using the sources:

* [elections.ca](http://elections.ca/)
* [parl.gc.ca](http://www.parl.gc.ca/)
* [conservative.ca](http://www.conservative.ca/)
* [greenparty.ca](http://www.greenparty.ca/)
* [liberal.ca](https://www.liberal.ca/)
* [ndp.ca](http://www.ndp.ca/)
* [cbc.ca](http://www.cbc.ca/)
* [digital-copyright.ca](http://www.digital-copyright.ca/)

These sources can be unstable or incorrect.

```ruby
require 'govkit-ca'

# Register the sources to use.
GovKit::CA::PostalCode::StrategySet.register(GovKit::CA::PostalCode::Strategy::ElectionsCa)
GovKit::CA::PostalCode::StrategySet.register(GovKit::CA::PostalCode::Strategy::LiberalCa)
GovKit::CA::PostalCode::StrategySet.register(GovKit::CA::PostalCode::Strategy::NDPCa)

GovKit::CA::PostalCode.find_electoral_districts_by_postal_code('A1A1A1') # [10007]
GovKit::CA::PostalCode.find_electoral_districts_by_postal_code('K0A1K0') # [35076]
GovKit::CA::PostalCode.find_electoral_districts_by_postal_code('H0H0H0') # raises GovKit::CA::ResourceNotFound

GovKit::CA::PostalCode.find_province_by_postal_code('A1A1A1') # "Newfoundland and Labrador"
GovKit::CA::PostalCode.find_province_by_postal_code('K0A1K0') # "Ontario"
GovKit::CA::PostalCode.find_province_by_postal_code('H0H0H0') # "Quebec"
```

Postal codes may contain lowercase letters. Spaces and non-alphanumeric characters are removed before processing.

GovKit-CA will raise `GovKit::CA::ResourceNotFound` if the electoral districts within a postal code cannot be determined, and `GovKit::CA::InvalidRequest` if a postal code is not properly formatted.

## Acknowledgements

GovKit-CA interoperates with the [Participatory Politics Foundation](http://www.participatorypolitics.org/)'s [GovKit](https://github.com/opengovernment/govkit). GovKit-CA is not affiliated with the Participatory Politics Foundation or GovKit.

## Bugs? Questions?

This gem's main repository is on GitHub: [https://github.com/opennorth/govkit-ca](https://github.com/opennorth/govkit-ca), where your contributions, forks, bug reports, feature requests, and feedback are greatly welcomed.

Copyright (c) 2011 Open North Inc., released under the MIT license

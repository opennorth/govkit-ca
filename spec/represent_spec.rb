require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe GovKit::CA::Represent do
  it 'should accept a custom connection' do
    connection = Faraday.new do |connection|
      connection.request :url_encoded
      connection.adapter Faraday.default_adapter
    end
    expect{GovKit::CA::Represent.new(connection)}.to_not raise_error
  end

  describe '#representative_sets' do
    include_examples 'set', 'representative_sets', 'house-of-commons'
  end

  # @note These tests will fail if the election is inactive.
  describe '#elections' do
    include_examples 'set', 'elections', 'house-of-commons'
  end

  describe '#boundary_sets' do
    include_examples 'set', 'boundary_sets', 'federal-electoral-districts'
  end

  describe '#representatives' do
    include_examples 'representative', 'representatives', 'st-johns-city-council', 11, :set => :representative_set, :point => :point
  end

  # @note These tests will fail if the election is inactive.
  describe '#candidates' do
    include_examples 'representative', 'candidates', 'house-of-commons', 20, :set => :election, :point => :point
  end

  describe '#boundaries' do
    include_examples 'item', 'boundaries', 'st-johns-wards', 5, :set => :boundary_set, :point => :contains

    let :api do
      GovKit::CA::Represent.new
    end

    it 'should raise an error if the boundary set does not exist' do
      expect{api.boundaries(:boundary_set => 'nonexistent')}.to raise_error(GovKit::CA::ResourceNotFound, "404 https://represent.opennorth.ca/boundaries/nonexistent/?")
    end

    it 'should return boundaries from many boundary sets as an array' do
      response = api.boundaries(:sets => ['st-johns-wards','caledon-wards'])
      expect(response).to be_a(Hash)
      expect(response).to have_key('objects')
      expect(response).to have_key('meta')
      expect(response['objects'].size).to eq(10)
    end

    it 'should return boundaries from many boundary sets as a comma-separated list' do
      response = api.boundaries(:sets => 'st-johns-wards,caledon-wards')
      expect(response).to be_a(Hash)
      expect(response).to have_key('objects')
      expect(response).to have_key('meta')
      expect(response['objects'].size).to eq(10)
    end

    context 'when retrieving a boundary' do
      it 'should return a boundary from a boundary set' do
        response = api.boundaries(:boundary_set => 'st-johns-wards', :boundary => 'ward-1')
        expect(response).to be_a(Hash)
        expect(response).to have_key('related')
      end

      it 'should raise an error if the boundary set does not exist' do
        expect{api.boundaries(:boundary_set => 'nonexistent', :boundary => 'ward-1')}.to raise_error(GovKit::CA::ResourceNotFound, "404 https://represent.opennorth.ca/boundaries/nonexistent/ward-1/?")
      end

      it 'should raise an error if the boundary does not exist' do
        expect{api.boundaries(:boundary_set => 'st-johns-wards', :boundary => 'nonexistent')}.to raise_error(GovKit::CA::ResourceNotFound, "404 https://represent.opennorth.ca/boundaries/st-johns-wards/nonexistent/?")
      end

      it 'should raise an error if the boundary set is not given' do
        expect{api.boundaries(:boundary => 'ward-1')}.to raise_error(ArgumentError, ':boundary_set must be set if :boundary is set')
      end
    end

    context 'when retrieving the representatives of a boundary' do
      it 'should return the representatives of a boundary from a boundary set' do
        response = api.boundaries(:boundary_set => 'st-johns-wards', :boundary => 'ward-1', :representatives => true)
        expect(response).to be_a(Hash)
        expect(response).to have_key('objects')
        expect(response).to have_key('meta')
        expect(response['meta']['next']).to be_nil
      end

      it 'should not raise an error if the boundary set does not exist' do
        expect{api.boundaries(:boundary_set => 'nonexistent', :boundary => 'ward-1', :representatives => true)}.to_not raise_error
      end

      it 'should not raise an error if the boundary does not exist' do
        expect{api.boundaries(:boundary_set => 'st-johns-wards', :boundary => 'nonexistent', :representatives => true)}.to_not raise_error
      end

      it 'should raise an error if the boundary set is not given' do
        expect{api.boundaries(:representatives => true)}.to raise_error(ArgumentError, ':boundary_set and :boundary must be set if :representatives is true')
      end

      it 'should raise an error if the boundary is not given' do
        expect{api.boundaries(:boundary_set => 'st-johns-wards', :representatives => true)}.to raise_error(ArgumentError, ':boundary_set and :boundary must be set if :representatives is true')
      end
    end
  end

  describe '#postcodes' do
    let :api do
      GovKit::CA::Represent.new
    end

    it 'should query by postal code' do
      response = api.postcodes('A1A1A1')
      expect(response).to be_a(Hash)
      expect(response).to have_key('code')
    end

    it 'should accept an array of boundary sets' do
      response = api.postcodes('A1A1A1', :sets => ['federal-electoral-districts', 'census-subdivisions'])
      expect(response).to be_a(Hash)
      expect((response['boundaries_centroid'] + response['boundaries_concordance']).size).to eq(2)
    end

    it 'should accept a comma-separated list of boundary sets' do
      response = api.postcodes('A1A1A1', :sets => 'federal-electoral-districts,census-subdivisions')
      expect(response).to be_a(Hash)
      expect((response['boundaries_centroid'] + response['boundaries_concordance']).size).to eq(2)
    end

    it 'should raise an error if the postal code does not exist' do
      expect{api.postcodes('Z0Z0Z0')}.to raise_error(GovKit::CA::ResourceNotFound, "404 https://represent.opennorth.ca/postcodes/Z0Z0Z0/?")
    end
  end
end

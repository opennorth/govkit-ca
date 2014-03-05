require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GovKit::CA::Represent do
  describe '#boundary_sets' do
    let :api do
      GovKit::CA::Represent.new
    end

    it 'should return boundary sets' do
      response = api.boundary_sets
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
    end

    it 'should return a boundary set' do
      response = api.boundary_sets(:boundary_set => 'federal-electoral-districts')
      response.should be_a(Hash)
      response.should have_key('related')
    end

    it 'should raise an error if the boundary set does not exist' do
      expect{api.boundary_sets(:boundary_set => 'foo')}.to raise_error(GovKit::CA::ResourceNotFound, "404 http://represent.opennorth.ca/boundary-sets/foo/?")
    end

    it 'should raise an error if the limit is invalid' do
      expect{api.boundary_sets(:limit => -1)}.to raise_error(GovKit::CA::InvalidRequest, "400 http://represent.opennorth.ca/boundary-sets/?limit=-1 Invalid limit '-1' provided. Please provide a positive integer >= 0.")
    end

    it 'should raise an error if the offset is invalid' do
      expect{api.boundary_sets(:offset => -1)}.to raise_error(GovKit::CA::InvalidRequest, "400 http://represent.opennorth.ca/boundary-sets/?offset=-1 Invalid offset '-1' provided. Please provide a positive integer >= 0.")
    end
  end

  describe '#representative_sets' do
    let :api do
      GovKit::CA::Represent.new
    end

    it 'should return representative sets' do
      response = api.representative_sets
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
    end

    it 'should return a representative set' do
      response = api.representative_sets(:representative_set => 'house-of-commons')
      response.should be_a(Hash)
      response.should have_key('related')
    end

    it 'should raise an error if the representative set does not exist' do
      expect{api.representative_sets(:representative_set => 'foo')}.to raise_error(GovKit::CA::ResourceNotFound, "404 http://represent.opennorth.ca/representative-sets/foo/?")
    end

    it 'should raise an error if the limit is invalid' do
      expect{api.representative_sets(:limit => -1)}.to raise_error(GovKit::CA::InvalidRequest, "400 http://represent.opennorth.ca/representative-sets/?limit=-1 Invalid limit '-1' provided. Please provide a positive integer >= 0.")
    end

    it 'should raise an error if the offset is invalid' do
      expect{api.representative_sets(:offset => -1)}.to raise_error(GovKit::CA::InvalidRequest, "400 http://represent.opennorth.ca/representative-sets/?offset=-1 Invalid offset '-1' provided. Please provide a positive integer >= 0.")
    end
  end

  describe '#postcodes' do
    let :api do
      GovKit::CA::Represent.new
    end

    it 'should query by postal code' do
      response = api.postcodes('A1A1A1')
      response.should be_a(Hash)
      response.should have_key('code')
    end

    it 'should accept an array of boundary sets' do
      response = api.postcodes('A1A1A1', :sets => ['federal-electoral-districts', 'census-subdivisions'])
      response.should be_a(Hash)
      response['boundaries_centroid'].should have(2).items
    end

    it 'should accept a comma-separated list of boundary sets' do
      response = api.postcodes('A1A1A1', :sets => 'federal-electoral-districts,census-subdivisions')
      response.should be_a(Hash)
      response['boundaries_centroid'].should have(2).items
    end

    it 'should raise an error if the postal code does not exist' do
      expect{api.postcodes('foo')}.to raise_error(GovKit::CA::ResourceNotFound, "404 http://represent.opennorth.ca/postcodes/foo/?")
    end
  end

  describe '#boundaries' do
    let :api do
      GovKit::CA::Represent.new
    end

    it 'should return boundaries' do
      response = api.boundaries
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['meta']['next'].should_not be_nil
    end

    it 'should return boundaries from a boundary set' do
      response = api.boundaries(:boundary_set => 'st-johns-wards')
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['objects'].should have(5).items
    end

    it 'should return a boundary from a boundary set' do
      response = api.boundaries(:boundary_set => 'st-johns-wards', :boundary => 'ward-1')
      response.should be_a(Hash)
      response.should have_key('related')
    end

    it 'should return the representatives of a boundary from a boundary set' do
      response = api.boundaries(:boundary_set => 'st-johns-wards', :boundary => 'ward-1', :representatives => true)
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['meta']['next'].should be_nil
    end

    it 'should return boundaries from many boundary sets as an array' do
      response = api.boundaries(:sets => ['st-johns-wards','caledon-wards'])
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['objects'].should have(10).items
    end

    it 'should return boundaries from many boundary sets as a comma-separated list' do
      response = api.boundaries(:sets => 'st-johns-wards,caledon-wards')
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['objects'].should have(10).items
    end

    it 'should accept a point as an array' do
      response = api.boundaries(:contains => ['47.5699', '-52.6954'])
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['meta']['next'].should be_nil
    end

    it 'should accept a point as a comma-separated list' do
      response = api.boundaries(:contains => '47.5699,-52.6954')
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['meta']['next'].should be_nil
    end

    it 'should raise an error if the point is invalid' do
      expect{api.boundaries(:contains => '0,0,0')}.to raise_error(GovKit::CA::InvalidRequest, "400 http://represent.opennorth.ca/boundaries/?contains=0,0,0 Invalid lat/lon values")
    end

    it 'should raise an error if the boundary set does not exist' do
      expect{api.boundaries(:boundary_set => 'foo')}.to raise_error(GovKit::CA::ResourceNotFound, "404 http://represent.opennorth.ca/boundaries/foo/?")
    end

    context 'when retrieving a boundary' do
      it 'should raise an error if the boundary set does not exist' do
        expect{api.boundaries(:boundary_set => 'foo', :boundary => 'ward-1')}.to raise_error(GovKit::CA::ResourceNotFound, "404 http://represent.opennorth.ca/boundaries/foo/ward-1/?")
      end

      it 'should raise an error if the boundary does not exist' do
        expect{api.boundaries(:boundary_set => 'st-johns-wards', :boundary => 'foo')}.to raise_error(GovKit::CA::ResourceNotFound, "404 http://represent.opennorth.ca/boundaries/st-johns-wards/foo/?")
      end

      it 'should raise an error if the boundary set is not given' do
        expect{api.boundaries(:boundary => 'ward-1')}.to raise_error(ArgumentError, ':boundary_set must be set if :boundary is set')
      end
    end

    context 'when retrieving the representatives of a boundary' do
      it 'should not raise an error if the boundary set does not exist' do
        expect{api.boundaries(:boundary_set => 'foo', :boundary => 'ward-1', :representatives => true)}.to_not raise_error
      end

      it 'should not raise an error if the boundary does not exist' do
        expect{api.boundaries(:boundary_set => 'st-johns-wards', :boundary => 'foo', :representatives => true)}.to_not raise_error
      end

      it 'should raise an error if the boundary set is not given' do
        expect{api.boundaries(:representatives => true)}.to raise_error(ArgumentError, ':boundary_set and :boundary must be set if :representatives is true')
      end

      it 'should raise an error if the boundary is not given' do
        expect{api.boundaries(:boundary_set => 'st-johns-wards', :representatives => true)}.to raise_error(ArgumentError, ':boundary_set and :boundary must be set if :representatives is true')
      end
    end

    it 'should raise an error if the limit is invalid' do
      expect{api.boundaries(:limit => -1)}.to raise_error(GovKit::CA::InvalidRequest, "400 http://represent.opennorth.ca/boundaries/?limit=-1 Invalid limit '-1' provided. Please provide a positive integer >= 0.")
    end

    it 'should raise an error if the offset is invalid' do
      expect{api.boundaries(:offset => -1)}.to raise_error(GovKit::CA::InvalidRequest, "400 http://represent.opennorth.ca/boundaries/?offset=-1 Invalid offset '-1' provided. Please provide a positive integer >= 0.")
    end
  end

  describe '#representatives' do
    let :api do
      GovKit::CA::Represent.new
    end

    it 'should return representatives' do
      response = api.representatives
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['meta']['next'].should_not be_nil
    end

    it 'should return representatives from a representative set' do
      response = api.representatives(:representative_set => 'st-johns-city-council')
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['meta']['next'].should be_nil
    end

    it 'should accept a point as an array' do
      response = api.representatives(:point => ['47.5699', '-52.6954'])
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['meta']['next'].should be_nil
    end

    it 'should accept a point as a comma-separated list' do
      response = api.representatives(:point => '47.5699,-52.6954')
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['meta']['next'].should be_nil
    end

    it 'should accept an array of districts' do
      response = api.representatives(:districts => ['federal-electoral-districts/10007', 'census-subdivisions/1001519'])
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['meta']['next'].should be_nil
    end

    it 'should accept a comma-separated list of districts' do
      response = api.representatives(:districts => 'federal-electoral-districts/10007,census-subdivisions/1001519')
      response.should be_a(Hash)
      response.should have_key('objects')
      response.should have_key('meta')
      response['meta']['next'].should be_nil
    end

    it 'should raise an error if the point is invalid' do
      expect{api.representatives(:point => '0,0,0')}.to raise_error(GovKit::CA::InvalidRequest, "400 http://represent.opennorth.ca/representatives/?point=0,0,0 Invalid lat/lon values")
    end

    it 'should not raise an error if the representative set does not exist' do
      expect{api.representatives(:representative_set => 'foo')}.to_not raise_error
    end

    it 'should raise an error if the limit is invalid' do
      expect{api.representatives(:limit => -1)}.to raise_error(GovKit::CA::InvalidRequest, "400 http://represent.opennorth.ca/representatives/?limit=-1 Invalid limit '-1' provided. Please provide a positive integer >= 0.")
    end

    it 'should raise an error if the offset is invalid' do
      expect{api.representatives(:offset => -1)}.to raise_error(GovKit::CA::InvalidRequest, "400 http://represent.opennorth.ca/representatives/?offset=-1 Invalid offset '-1' provided. Please provide a positive integer >= 0.")
    end
  end
end

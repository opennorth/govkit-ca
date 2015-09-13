RSpec.shared_examples 'pagination' do |method,endpoint|
  it 'should raise an error if the limit is invalid' do
    expect{api.send(method, :limit => -1)}.to raise_error(GovKit::CA::InvalidRequest, "400 https://represent.opennorth.ca/#{endpoint}/?limit=-1 Invalid limit '-1' provided. Please provide a positive integer >= 0.")
  end

  it 'should raise an error if the offset is invalid' do
    expect{api.send(method, :offset => -1)}.to raise_error(GovKit::CA::InvalidRequest, "400 https://represent.opennorth.ca/#{endpoint}/?offset=-1 Invalid offset '-1' provided. Please provide a positive integer >= 0.")
  end
end

RSpec.shared_examples 'set' do |method,set|
  include_examples 'pagination', method, method.sub('_', '-')

  let :option do
    method.chomp('s').to_sym
  end

  let :endpoint do
    method.sub('_', '-')
  end

  let :api do
    GovKit::CA::Represent.new
  end

  it 'should return sets' do
    response = api.send(method)
    expect(response).to be_a(Hash)
    expect(response).to have_key('objects')
    expect(response).to have_key('meta')
  end

  it 'should return a set' do
    response = api.send(method, option => set)
    expect(response).to be_a(Hash)
    expect(response).to have_key('related')
  end

  it 'should raise an error if the set does not exist' do
    expect{api.send(method, option => 'nonexistent')}.to raise_error(GovKit::CA::ResourceNotFound, "404 https://represent.opennorth.ca/#{endpoint}/nonexistent/?")
  end
end

RSpec.shared_examples 'item' do |method,set,size,options|
  include_examples 'pagination', method, method

  let :endpoint do
    method
  end

  let :api do
    GovKit::CA::Represent.new
  end

  it 'should return items' do
    response = api.send(method)
    expect(response).to be_a(Hash)
    expect(response).to have_key('objects')
    expect(response).to have_key('meta')
    expect(response['meta']['next']).to_not be_nil
  end

  it 'should return items from a set' do
    response = api.send(method, options.fetch(:set) => set)
    expect(response).to be_a(Hash)
    expect(response).to have_key('objects')
    expect(response).to have_key('meta')
    expect(response['objects'].size).to eq(size)
  end

  it 'should accept a point as an array' do
    response = api.send(method, options.fetch(:point) => ['47.5699', '-52.6954'])
    expect(response).to be_a(Hash)
    expect(response).to have_key('objects')
    expect(response).to have_key('meta')
    expect(response['meta']['next']).to be_nil
  end

  it 'should accept a point as a comma-separated list' do
    response = api.send(method, options.fetch(:point) => '47.5699,-52.6954')
    expect(response).to be_a(Hash)
    expect(response).to have_key('objects')
    expect(response).to have_key('meta')
    expect(response['meta']['next']).to be_nil
  end

  it 'should raise an error if the point is invalid' do
    expect{api.send(method, options.fetch(:point) => '0,0,0')}.to raise_error(GovKit::CA::InvalidRequest, "400 https://represent.opennorth.ca/#{endpoint}/?#{options[:point]}=0,0,0 Invalid latitude,longitude '0,0,0' provided.")
  end
end

RSpec.shared_examples 'representative' do |method,set,size,options|
  include_examples 'item', method, set, size, options

  let :api do
    GovKit::CA::Represent.new
  end

  it 'should not raise an error if the set does not exist' do
    expect{api.send(method, options.fetch(:set) => 'foo')}.to_not raise_error
  end

  it 'should accept an array of districts' do
    response = api.send(method, :districts => ['federal-electoral-districts/10007', 'census-subdivisions/1001519'])
    expect(response).to be_a(Hash)
    expect(response).to have_key('objects')
    expect(response).to have_key('meta')
    expect(response['meta']['next']).to be_nil
  end

  it 'should accept a comma-separated list of districts' do
    response = api.send(method, :districts => 'federal-electoral-districts/10007,census-subdivisions/1001519')
    expect(response).to be_a(Hash)
    expect(response).to have_key('objects')
    expect(response).to have_key('meta')
    expect(response['meta']['next']).to be_nil
  end
end

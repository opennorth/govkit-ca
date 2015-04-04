require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe GovKit::CA::PostalCode do
  before :all do
    GovKit::CA::PostalCode::StrategySet.register GovKit::CA::PostalCode::Strategy::ElectionsCa
    GovKit::CA::PostalCode::StrategySet.register GovKit::CA::PostalCode::Strategy::LiberalCa
    GovKit::CA::PostalCode::StrategySet.register GovKit::CA::PostalCode::Strategy::NDPCa
  end

  describe '#valid?' do
    it 'should return false if the postal code is not properly formatted' do
      [ 'A1A1A', # too short
        'A1A1A1A', # too long
        "A1A1A1\nA1A1A1", # multiline
        'AAAAAA', # no digits
        '111111', # no letters
        '1A1A1A', # wrong order
        'Z1Z1Z1', # Z as first letter
        'Q1Q1Q1', # Q as letter
        'a1a1a1', # lowercase
      ].each do |postal_code|
        expect(subject.valid?(postal_code)).to eq(false)
      end
    end

    it 'should return true if the postal code is properly formatted' do
      [ 'A1Z1Z1', # Z not as first letter
        'H0H0H0', # doesn't exist
        'A1A1A1', # does exist
      ].each do |postal_code|
        expect(subject.valid?(postal_code)).to eq(true)
      end
    end
  end

  describe '#find_electoral_districts_by_postal_code' do
    it 'should return the electoral districts within a postal code' do
      { 'A1A1A1' => [10007],
        'K0A1K0' => [35076],
      }.each do |postal_code,electoral_districts|
        expect(subject.find_electoral_districts_by_postal_code(postal_code)).to eq(electoral_districts)
      end
    end

    it 'should raise an error if the postal code cannot be determined' do
      expect(lambda{subject.find_electoral_districts_by_postal_code('H0H0H0')}).to raise_error(GovKit::CA::ResourceNotFound)
    end

    it 'should raise an error if the postal code is invalid' do
      expect(lambda{subject.find_electoral_districts_by_postal_code('AAAAAA')}).to raise_error(GovKit::CA::InvalidRequest)
    end
  end

  describe '#find_province_by_postal_code' do
    it 'should return the province that a postal code belongs to' do
      { 'A' => 'Newfoundland and Labrador',
        'B' => 'Nova Scotia',
        'C' => 'Prince Edward Island',
        'E' => 'New Brunswick',
        'G' => 'Quebec',
        'H' => 'Quebec',
        'J' => 'Quebec',
        'K' => 'Ontario',
        'L' => 'Ontario',
        'M' => 'Ontario',
        'N' => 'Ontario',
        'P' => 'Ontario',
        'R' => 'Manitoba',
        'S' => 'Saskatchewan',
        'T' => 'Alberta',
        'V' => 'British Columbia',
        'X0A' => 'Nunavut',
        'X0B' => 'Nunavut',
        'X0C' => 'Nunavut',
        'X0E' => 'Northwest Territories',
        'X0G' => 'Northwest Territories',
        'X1A' => 'Northwest Territories',
        'Y' => 'Yukon',
      }.each do |postal_code,province|
        expect(subject.find_province_by_postal_code(postal_code)).to eq(province)
      end
    end

    it 'should raise an error if the province cannot be determined' do
      expect(lambda{subject.find_province_by_postal_code('X1B1B1')}).to raise_error(GovKit::CA::ResourceNotFound)
    end
  end

  describe '#format_postal_code' do
    it 'should format a postal code' do
      expect(subject.format_postal_code("+a1a 1a1\n")).to eq('A1A1A1')
    end
  end
end

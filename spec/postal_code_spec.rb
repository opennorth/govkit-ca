require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module GovKit::CA::PostalCode
  describe GovKit::CA::PostalCode do
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
          subject.valid?(postal_code).should be_false
        end
      end

      it 'should return true if the postal code is properly formatted' do
        [ 'A1Z1Z1', # Z not as first letter
          'H0H0H0', # doesn't exist
          'A1A1A1', # does exist
        ].each do |postal_code|
          subject.valid?(postal_code).should be_true
        end
      end
    end

    describe '#find_electoral_districts_by_postal_code' do
      it 'should return the electoral districts within a postal code' do
        { 'A1A1A1' => [10007],
          'K0A1K0' => [35012, 35025, 35040, 35052, 35063, 35064, 35087],
        }.each do |postal_code,electoral_districts|
          subject.find_electoral_districts_by_postal_code(postal_code).should == electoral_districts
        end
      end

      it 'should raise an error if the postal code cannot be determined' do
        lambda{subject.find_electoral_districts_by_postal_code('H0H0H0')}.should raise_error(GovKit::CA::ResourceNotFound)
      end

      it 'should raise an error if the postal code is invalid' do
        lambda{subject.find_electoral_districts_by_postal_code('AAAAAA')}.should raise_error(GovKit::CA::InvalidRequest)
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
        }.each do |postal_code, province|
          subject.find_province_by_postal_code(postal_code).should == province
        end
      end

      it 'should raise an error if the province cannot be determined' do
        lambda{subject.find_province_by_postal_code('X1B1B1')}.should raise_error(GovKit::CA::ResourceNotFound)
      end
    end

    describe '#format_postal_code' do
      it 'should format a postal code' do
        subject.format_postal_code("+a1a 1a1\n").should == 'A1A1A1'
      end
    end
  end
end

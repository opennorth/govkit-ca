require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'gov_kit-ca/postal_code/strategy/elections_ca'

describe GovKit::CA::PostalCode::Strategy::ElectionsCa do
  describe '#electoral_districts' do
    it 'should return the electoral districts within a postal code' do
      { 'G0C2Y0' => [24019],
        # returns nothing for T5S2B9
      }.each do |postal_code,electoral_districts|
        GovKit::CA::PostalCode::Strategy::ElectionsCa.new(postal_code).electoral_districts.should == electoral_districts
      end
    end

    it 'should (unfortunately) return false if a postal code contains multiple electoral districts' do
      GovKit::CA::PostalCode::Strategy::ElectionsCa.new('K0A1K0').electoral_districts.should be_false # B0J2L0
    end

    it 'should return false if a postal code contains no electoral districts' do
      GovKit::CA::PostalCode::Strategy::ElectionsCa.new('H0H0H0').electoral_districts.should be_false
    end

    it 'should return false if a postal code does not exist' do
      GovKit::CA::PostalCode::Strategy::ElectionsCa.new('X1B1B1').electoral_districts.should be_false
    end
  end
end

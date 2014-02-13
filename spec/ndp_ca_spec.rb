require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'gov_kit-ca/postal_code/strategy/ndp_ca'

describe GovKit::CA::PostalCode::Strategy::NDPCa do
  describe '#electoral_districts' do
    it 'should return the electoral districts within a postal code' do
      { 'G0C2Y0' => [24019],
        'T5S2B9' => [48015],
        'K0A1K0' => [35012, 35025, 35040, 35052],
        'B0J2L0' => [12002, 12006, 12009, 12011],
      }.each do |postal_code,electoral_districts|
        GovKit::CA::PostalCode::Strategy::NDPCa.new(postal_code).electoral_districts.should == electoral_districts
      end
    end

    it 'should return false if a postal code contains no electoral districts' do
      GovKit::CA::PostalCode::Strategy::NDPCa.new('H0H0H0').electoral_districts.should be_false
    end

    it 'should return false if a postal code does not exist' do
      GovKit::CA::PostalCode::Strategy::NDPCa.new('X1B1B1').electoral_districts.should be_false
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'gov_kit-ca/postal_code/strategy/greenparty_ca'

describe GovKit::CA::PostalCode::Strategy::GreenPartyCa do
  describe '#electoral_districts' do
    it 'should return the electoral districts within a postal code' do
      pending # 2014-09-28 The API is returning false for any postal code.

      { 'G0C2Y0' => [24019],
        'T5S2B9' => [48015],
      }.each do |postal_code,electoral_districts|
        GovKit::CA::PostalCode::Strategy::GreenPartyCa.new(postal_code).electoral_districts.should == electoral_districts
      end
    end

    it 'should (unfortunately) return false if a postal code contains multiple electoral districts' do
      GovKit::CA::PostalCode::Strategy::GreenPartyCa.new('K0A1K0').electoral_districts.should be_false # B0J2L0
    end

    it 'should return false if a postal code contains no electoral districts' do
      GovKit::CA::PostalCode::Strategy::GreenPartyCa.new('H0H0H0').electoral_districts.should be_false
    end

    it 'should return false if a postal code does not exist' do
      GovKit::CA::PostalCode::Strategy::GreenPartyCa.new('X1B1B1').electoral_districts.should be_false
    end
  end
end

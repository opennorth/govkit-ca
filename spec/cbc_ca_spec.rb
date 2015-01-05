require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GovKit::CA::PostalCode::Strategy::CBCCa do
  describe '#electoral_districts', :broken => true do
    it 'should return the electoral districts within a postal code' do
      { 'G0C2Y0' => [24019],
        'T5S2B9' => [48015, 48017], # too many 48015
        'B0J2L0' => [12002, 12007, 12008],
        'K0A1K0' => [35025, 35052, 35063, 35064],
      }.each do |postal_code,electoral_districts|
        GovKit::CA::PostalCode::Strategy::CBCCa.new(postal_code).electoral_districts.should == electoral_districts
      end
    end

    it 'should return false if a postal code contains no electoral districts' do
      GovKit::CA::PostalCode::Strategy::CBCCa.new('H0H0H0').electoral_districts.should be_false
    end

    it 'should return false if a postal code does not exist' do
      GovKit::CA::PostalCode::Strategy::CBCCa.new('X1B1B1').electoral_districts.should be_false
    end
  end
end

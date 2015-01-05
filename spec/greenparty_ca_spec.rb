require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GovKit::CA::PostalCode::Strategy::GreenPartyCa do
  describe '#electoral_districts' do
    it 'should return the electoral districts within a postal code' do
      { 'G0C2Y0' => [24026],
        'T5S2B9' => [48031],
        'B0J2L0' => [12002], # too few
        'K0A1K0' => [35076], # too few
        'H0H0H0' => [24036], # wrong
      }.each do |postal_code,electoral_districts|
        GovKit::CA::PostalCode::Strategy::GreenPartyCa.new(postal_code).electoral_districts.should == electoral_districts
      end
    end

    it 'should return false if a postal code does not exist' do
      GovKit::CA::PostalCode::Strategy::GreenPartyCa.new('X1B1B1').electoral_districts.should be_false
    end
  end
end

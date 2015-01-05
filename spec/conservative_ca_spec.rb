require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GovKit::CA::PostalCode::Strategy::ConservativeCa do
  describe '#electoral_districts' do
    it 'should return the electoral districts within a postal code' do
      { 'T1P1K1' => [48010],
        'K0A1K0' => [35025, 35052, 35063],
      }.each do |postal_code,electoral_districts|
        GovKit::CA::PostalCode::Strategy::ConservativeCa.new(postal_code).electoral_districts.should == electoral_districts
      end
    end

    it 'should (unfortunately) return false if a postal code is held by another party' do
      GovKit::CA::PostalCode::Strategy::ConservativeCa.new('G0C2Y0').electoral_districts.should be_false
      GovKit::CA::PostalCode::Strategy::ConservativeCa.new('T5S2B9').electoral_districts.should be_false
      GovKit::CA::PostalCode::Strategy::ConservativeCa.new('B0J2L0').electoral_districts.should be_false
    end

    it 'should return false if a postal code contains no electoral districts' do
      GovKit::CA::PostalCode::Strategy::ConservativeCa.new('H0H0H0').electoral_districts.should be_false
    end

    it 'should return false if a postal code does not exist' do
      GovKit::CA::PostalCode::Strategy::ConservativeCa.new('X1B1B1').electoral_districts.should be_false
    end
  end
end

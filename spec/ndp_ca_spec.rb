require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class GovKit::CA::PostalCode::Strategy::NDPCa
  describe GovKit::CA::PostalCode::Strategy::NDPCa do
    describe '#electoral_districts' do
      it 'should return the electoral districts within a postal code' do
        { 'G0C2Y0' => [24019],
          'T5S2B9' => [48015], # differs from cbc.ca
        }.each do |postal_code,electoral_districts|
          GovKit::CA::PostalCode::Strategy::NDPCa.new(postal_code).electoral_districts.should == electoral_districts
        end
      end

      it 'should (unfortunately) return false if a postal code contains multiple electoral districts' do
        GovKit::CA::PostalCode::Strategy::NDPCa.new('K0A1K0').electoral_districts.should be_false
      end

      it 'should return false if a postal code contains no electoral districts' do
        GovKit::CA::PostalCode::Strategy::NDPCa.new('H0H0H0').electoral_districts.should be_false
      end

      it 'should return false if a postal code does not exist' do
        GovKit::CA::PostalCode::Strategy::NDPCa.new('X1B1B1').electoral_districts.should be_false
      end
    end
  end
end

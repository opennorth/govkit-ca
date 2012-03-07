require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class GovKit::CA::PostalCode::Strategy::CBCCa
  describe GovKit::CA::PostalCode::Strategy::CBCCa do
    describe '#electoral_districts' do
      before :all do
        %w(G0C2Y0 T5S2B9 K0A1K0 H0H0H0 X1B1B1).each do |postal_code|
          strategy = GovKit::CA::PostalCode::Strategy::CBCCa.new(postal_code)
          unless FakeWeb.allow_net_connect?
            FakeWeb.register_uri strategy.class.http_method, "#{strategy.class.base_uri}#{strategy.send(:path)}", :response => fixture_path('cbc_ca', "#{postal_code}.response")
          end
        end
      end

      it 'should return the electoral districts within a postal code' do
        { 'G0C2Y0' => [24019],
          'T5S2B9' => [48015, 48017], # differs from elections.ca, ndp.ca, greenparty.ca, liberal.ca
          'K0A1K0' => [35025, 35052, 35063, 35064], # differs from liberal.ca, digital-copyright.ca
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
end

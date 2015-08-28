require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe GovKit::CA::PostalCode::Strategy::CBCCa do
  describe '#electoral_districts', :broken => true do
    it 'should return the electoral districts within a postal code' do
      EXPECTATIONS[:cbc_ca].each do |postal_code,electoral_districts|
        expect(GovKit::CA::PostalCode::Strategy::CBCCa.new(postal_code).electoral_districts).to eq(electoral_districts)
      end
    end

    it 'should return false if a postal code contains no electoral districts' do
      expect(GovKit::CA::PostalCode::Strategy::CBCCa.new('H0H0H0').electoral_districts).to eq(false)
    end

    it 'should return false if a postal code does not exist' do
      expect(GovKit::CA::PostalCode::Strategy::CBCCa.new('X1B1B1').electoral_districts).to eq(false)
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe GovKit::CA::PostalCode::Strategy::GreenPartyCa do
  describe '#electoral_districts' do
    it 'should return the electoral districts within a postal code' do
      { 'G0C2Y0' => [24026],
        'T5S2B9' => [48031],
      }.each do |postal_code,electoral_districts|
        expect(GovKit::CA::PostalCode::Strategy::GreenPartyCa.new(postal_code).electoral_districts).to eq(electoral_districts)
      end
    end

    it 'should (unfortunately) return false if a postal code contains multiple electoral districts' do
      expect(GovKit::CA::PostalCode::Strategy::GreenPartyCa.new('B0J2L0').electoral_districts).to eq(false)
      expect(GovKit::CA::PostalCode::Strategy::GreenPartyCa.new('K0A1K0').electoral_districts).to eq(false)
    end

    it 'should return false if a postal code contains no electoral districts' do
      expect(GovKit::CA::PostalCode::Strategy::GreenPartyCa.new('H0H0H0').electoral_districts).to eq(false)
    end

    it 'should return false if a postal code does not exist' do
      expect(GovKit::CA::PostalCode::Strategy::GreenPartyCa.new('X1B1B1').electoral_districts).to eq(false)
    end
  end
end

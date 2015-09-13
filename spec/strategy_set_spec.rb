require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe GovKit::CA::PostalCode::StrategySet do
  let :strategy do
    Class.new
  end

  context 'with strategy set' do
    before :all do
      GovKit::CA::PostalCode::StrategySet.register GovKit::CA::PostalCode::Strategy::ElectionsCa
      GovKit::CA::PostalCode::StrategySet.register GovKit::CA::PostalCode::Strategy::LiberalCa
      GovKit::CA::PostalCode::StrategySet.register GovKit::CA::PostalCode::Strategy::NDPCa
    end

    describe '#strategies' do
      it 'should return the strategies' do
        expect(GovKit::CA::PostalCode::StrategySet.strategies[0..4]).to eq([
          GovKit::CA::PostalCode::Strategy::ElectionsCa,
          GovKit::CA::PostalCode::Strategy::LiberalCa,
          GovKit::CA::PostalCode::Strategy::NDPCa,
          # GovKit::CA::PostalCode::Strategy::GreenPartyCa,
          # GovKit::CA::PostalCode::Strategy::ConservativeCa,
        ])
      end
    end

    describe '#register' do
      it 'should append a strategy' do
        GovKit::CA::PostalCode::StrategySet.register(strategy)
        expect(GovKit::CA::PostalCode::StrategySet.strategies.last).to eq(strategy)
      end
    end

    describe '#run' do
      it 'should run the strategies' do
        expect(GovKit::CA::PostalCode::StrategySet.run('A1A1A1')).to eq([10007])
      end
    end
  end

  context 'with empty strategy set' do
    before :each do
      GovKit::CA::PostalCode::StrategySet.strategies.clear
    end

    describe '#strategies' do
      it 'should return the strategies' do
        expect(GovKit::CA::PostalCode::StrategySet.strategies).to eq([])
      end
    end

    describe '#register' do
      it 'should add a strategy' do
        GovKit::CA::PostalCode::StrategySet.register(strategy)
        expect(GovKit::CA::PostalCode::StrategySet.strategies).to eq([strategy])
      end
    end

    describe '#run' do
      it 'should raise an error' do
        expect{GovKit::CA::PostalCode::StrategySet.run('A1A1A1')}.to raise_error(GovKit::CA::ResourceNotFound)
      end
    end
  end
end

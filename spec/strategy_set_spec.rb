require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GovKit::CA::PostalCode::StrategySet do
  let :strategy do
    Class.new
  end

  describe '#strategies' do
    it 'should return the strategies' do
      GovKit::CA::PostalCode::StrategySet.strategies.should == [
        GovKit::CA::PostalCode::Strategy::ElectionsCa,
        GovKit::CA::PostalCode::Strategy::NDPCa,
        GovKit::CA::PostalCode::Strategy::LiberalCa,
        GovKit::CA::PostalCode::Strategy::GreenPartyCa,
        GovKit::CA::PostalCode::Strategy::CBCCa,
      ]
    end
  end

  describe '#register' do
    it 'should append a strategy' do
      GovKit::CA::PostalCode::StrategySet.register(strategy)
      GovKit::CA::PostalCode::StrategySet.strategies.last.should == strategy
    end
  end

  describe '#run' do
    it 'should run the strategies' do
      GovKit::CA::PostalCode::StrategySet.run('A1A1A1').should == [10007]
    end
  end

  context 'with empty strategy set' do
    before :each do
      GovKit::CA::PostalCode::StrategySet.strategies.clear
    end

    describe '#strategies' do
      it 'should return the strategies' do
        GovKit::CA::PostalCode::StrategySet.strategies.should == []
      end
    end

    describe '#register' do
      it 'should add a strategy' do
        GovKit::CA::PostalCode::StrategySet.register(strategy)
        GovKit::CA::PostalCode::StrategySet.strategies.should == [strategy]
      end
    end

    describe '#run' do
      it 'should raise an error' do
        expect{GovKit::CA::PostalCode::StrategySet.run('A1A1A1')}.to raise_error(GovKit::CA::ResourceNotFound)
      end
    end
  end
end

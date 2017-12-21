require 'rails_helper'

RSpec.describe Atm, type: :model do
  let(:money_attributes) do
    FactoryBot.attributes_for(:atm)
  end

  describe '.dispense' do
    it 'creates new atm state row with cash amount' do
      described_class.dispense money_attributes
      instance = described_class.instance
      money_attributes.each do |money_nominal, value|
        expect(instance.send(money_nominal)).to eq(value)
      end
    end

    it 'creates new atm state row with cash amount' do
      described_class.dispense money_attributes
      described_class.dispense money_attributes
      instance = described_class.instance
      money_attributes.each do |money_nominal, value|
        expect(instance.send(money_nominal)).to eq(value*2)
      end
    end

  end

  describe '.try_to_give' do
    attr_reader :instance

    before(:each) do
      described_class.dispense money_attributes
      @instance = described_class.instance
      instance.money_to_give = Atm::Money.new
      instance.remainder = 1000
    end

    it 'tries to give whole amount in hundreds' do
      instance.try_to_give(:hundreds)
      expect(instance.money_in_machine.hundreds).to eq(0)
      expect(instance.remainder).to eq(500)
    end

    it 'tries to give whole amount in fifties' do
      instance.try_to_give(:fifties)
      expect(instance.money_in_machine.fifties).to eq(10)
      expect(instance.remainder).to eq(0)
    end
  end

  describe '.withdraw' do
    context 'success (different nominals)' do
      it 'subtracts money from atm' do
        described_class.dispense money_attributes
        described_class.instance.withdraw(193)
        instance = described_class.instance

        money_attributes.each do |money_nominal, value|
          expect(instance.money_in_machine.send(money_nominal)).to eq(value-1)
        end
      end
    end

    context 'success' do
      it 'subtracts money from atm' do
        described_class.dispense money_attributes
        instance = described_class.instance
        instance.withdraw(1500)
        expect(instance.money_in_machine.hundreds).to eq(0)
        expect(instance.money_in_machine.fifties).to eq(10)
      end

      it 'adds money to money_to_give' do
        described_class.dispense money_attributes
        instance = described_class.instance
        instance.withdraw(1500)
        expect(instance.money_to_give.hundreds).to eq(5)
        expect(instance.money_to_give.fifties).to eq(20)
      end
    end

    context 'failure' do
      it 'throws an exception' do
        described_class.dispense money_attributes
        expect { 
          described_class.instance.withdraw(150000) 
        }.to raise_exception(Atm::NotEnoughMoneyError)
      end

    end
  end
end

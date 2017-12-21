require 'rails_helper'



RSpec.describe Atm, type: :model do
  let(:money_attributes) do
    {
      ones: 10,
      twos: 20,
      fives: 15,
      tens: 20,
      quarters: 10,
      fifties: 30,
      hundreds: 5,
    }
  end

  describe '.dispense' do
    it 'creates new atm state row with cash amount' do
      described_class.dispense money_attributes
      instance = described_class.instance
      money_attributes.each do |money_nominal, value|
        instance.send(money_nominal) == value
      end
    end

  end

  describe '.try_to_give_hundreds' do
    it 'tries to give whole amount in hundreds' do
      described_class.dispense money_attributes
      instance = described_class.instance
      instance.remainder = 1000
      instance.try_to_give_hundreds
      expect(instance.hundreds).to eq(0)
      expect(instance.remainder).to eq(500)
    end
  end

  describe '.try_to_give_fifties' do
    it 'tries to give whole amount in fifties' do
      described_class.dispense money_attributes
      instance = described_class.instance
      instance.remainder = 1000
      instance.try_to_give_fifties
      expect(instance.fifties).to eq(10)
      expect(instance.remainder).to eq(0)
    end
  end

  describe '.withdraw' do
    context 'success' do
      it 'subtracts money from atm' do
        described_class.dispense money_attributes
        described_class.instance.withdraw(1500)
        instance = described_class.instance
        expect(instance.hundreds).to eq(0)
        expect(instance.fifties).to eq(10)
      end
    end

    context 'failure' do
      it 'throws an exception' do
        described_class.dispense money_attributes
        expect { described_class.instance.withdraw(1500000) }.to raise_exception
      end

    end
  end
end

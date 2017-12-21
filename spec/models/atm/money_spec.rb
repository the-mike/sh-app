require 'rails_helper'

describe Atm::Money do
  describe 'initialize' do
    subject { described_class.new ones: 10, twos: 10, fives: 20 }
    it 'creates new money instance with correct attributes' do
      expect(subject.ones).to eq(10)
      expect(subject.fives).to eq(20)
    end

    it 'creates new money instance with zeroes for absent attributes' do
      expect(subject.fifties).to eq(0)
      expect(subject.quarters).to eq(0)
    end

  end

  describe '+' do
    it 'adds corresponding fields of two money object' do
      m1 = described_class.new ones: 10, hundreds: 100
      m2 = described_class.new ones: 100, hundreds: 20
      sum = m1 + m2
      expect(sum.ones).to eq(110)
      expect(sum.hundreds).to eq(120)
    end
  end

  describe '+' do
    it 'adds corresponding fields of two money object' do
      m1 = described_class.new ones: 100, hundreds: 100
      m2 = described_class.new ones: 100, hundreds: 20
      difference = m1 - m2
      expect(difference.ones).to eq(0)
      expect(difference.hundreds).to eq(80)
    end
  end

  describe '==' do
    it 'returns true if two instances has same amount of notes' do
      m1 = described_class.new ones: 100, hundreds: 100
      m2 = described_class.new ones: 100, hundreds: 100
      expect(m1 == m2).to eq(true)
    end

    it 'returns false if two instances has different amount of notes' do
      m1 = described_class.new ones: 100, hundreds: 120
      m2 = described_class.new ones: 100, hundreds: 100
      expect(m1 == m2).to eq(false)
    end
  end
end

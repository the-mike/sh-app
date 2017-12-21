require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Dispense' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  let(:money_attributes) do
    FactoryBot.attributes_for :atm
  end

  post '/dispense' do
    example 'single call adds money to ATM' do
      do_request money: money_attributes
      instance = Atm.instance
      expect(status).to eq(201)

      expect(instance.attributes.except('created_at', 'updated_at')).to eq(JSON.parse(response_body).without('created_at', 'updated_at'))

      money_attributes.each do |money_nominal, value|
        expect(instance.send(money_nominal)).to eq(value)
      end

    end

    example 'two calls add summed money to ATM' do
      do_request money: money_attributes
      do_request money: money_attributes

      expect(status).to eq(201)
      instance = Atm.instance

      money_attributes.each do |money_nominal, value|
        expect(instance.send(money_nominal)).to eq(value*2)
      end

    end

  end
end

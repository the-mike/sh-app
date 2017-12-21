require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Withdraw' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  let(:money_attributes) do
    FactoryBot.attributes_for :atm
  end

  post '/withdraw' do
    context 'success' do
      example do
        Atm.dispense(money_attributes)
        do_request amount: 100
        expect(status).to eq(200)
        expect(JSON.parse(response_body)['hundreds']).to eq(1)
      end


    end

    context 'failure' do
      example do
        Atm.dispense(money_attributes)
        do_request amount: 1000000
        expect(status).to eq(422)
      end

    end

  end
end


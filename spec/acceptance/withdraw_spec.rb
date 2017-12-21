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


    end

  end
end


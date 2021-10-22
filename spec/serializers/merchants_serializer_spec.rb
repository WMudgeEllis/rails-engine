require "rails_helper"

RSpec.describe MerchantsSerializer do
  it '#merchant_index' do
    create_list(:merchant, 21)

    response = MerchantsSerializer.merchant_index

    expect(response).to be_a(Hash)
    expect(response[:data]).to be_a(Array)
    expect(response[:data].length).to eq(20)
    expect(response[:data].first).to have_key(:id)
    expect(response[:data].first[:id]).to eq(Merchant.first.id)
    expect(response[:data].first).to have_key(:type)
    expect(response[:data].first[:type]).to eq('merchant')
    expect(response[:data].first).to have_key(:attributes)
    expect(response[:data].first[:attributes][:name]).to eq(Merchant.first.name)

  end
end

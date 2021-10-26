require "rails_helper"

RSpec.describe MerchantsSerializer do
  it '#merchant_index' do
    create_list(:merchant, 21)

    response = MerchantsSerializer.merchant_index

    expect(response).to be_a(Hash)
    expect(response[:data]).to be_a(Array)
    expect(response[:data].length).to eq(20)
    expect(response[:data].first).to have_key(:id)
    expect(response[:data].first[:id]).to eq(Merchant.first.id.to_s)
    expect(response[:data].first).to have_key(:type)
    expect(response[:data].first[:type]).to eq('merchant')
    expect(response[:data].first).to have_key(:attributes)
    expect(response[:data].first[:attributes][:name]).to eq(Merchant.first.name)
  end

  it '#merchant_index can get pages' do
    create_list(:merchant, 21)

    response = MerchantsSerializer.merchant_index(2)

    expect(response[:data].length).to eq(1)
  end

  it '#merchant_index returns empty array for page with no data' do
    create_list(:merchant, 21)

    response = MerchantsSerializer.merchant_index(10)

    expect(response[:data]).to eq([])
  end

  it '#merchant_index has optional page length' do
    create_list(:merchant, 100)

    response = MerchantsSerializer.merchant_index(2, 50)

    expect(response[:data].length).to eq(50)
  end

  it '#merchant_show' do
    create_list(:merchant, 3)

    merchant = Merchant.last

    response = MerchantsSerializer.merchant_show(merchant.id)

    expect(response[:data][:id]).to eq("#{merchant.id}")
    expect(response[:data][:type]).to eq('merchant')
    expect(response[:data][:attributes][:name]).to eq(merchant.name)
  end

  it '#merchant_items' do
    merchant = create(:merchant)
    create_list(:item, 5, merchant_id: merchant.id)
    item = Item.first

    response = MerchantsSerializer.merchant_items(merchant.id)

    expect(response[:data]).to be_a(Array)
    expect(response[:data].first[:id]).to eq(item.id.to_s)
    expect(response[:data].first[:type]).to eq('item')
    expect(response[:data].first).to have_key(:attributes)
    expect(response[:data].first[:attributes]).to be_a(Hash)
    expect(response[:data].first[:attributes][:name]).to eq(item.name)
    expect(response[:data].first[:attributes][:description]).to eq(item.description)
    expect(response[:data].first[:attributes][:unit_price]).to eq(item.unit_price)
    expect(response[:data].first[:attributes][:merchant_id]).to eq(item.merchant_id)
  end
end

require 'rails_helper'

RSpec.describe ItemsSerializer do
  it '#item_index' do
    merchant = create(:merchant)
    create_list(:item, 21, merchant_id: merchant.id)

    response = ItemsSerializer.item_index

    expect(response).to be_a(Hash)
    expect(response[:data]).to be_a(Array)
    expect(response[:data].length).to eq(20)
    expect(response[:data].first).to have_key(:id)
    expect(response[:data].first[:id]).to eq(Item.first.id.to_s)
    expect(response[:data].first).to have_key(:type)
    expect(response[:data].first[:type]).to eq('item')
    expect(response[:data].first).to have_key(:attributes)
    expect(response[:data].first[:attributes][:name]).to eq(Item.first.name)
    expect(response[:data].first[:attributes][:description]).to eq(Item.first.description)
    expect(response[:data].first[:attributes][:unit_price]).to eq(Item.first.unit_price)
    expect(response[:data].first[:attributes][:merchant_id]).to eq(Item.first.merchant_id)
  end

  it '#item_index can get pages' do
    merchant = create(:merchant)
    create_list(:item, 21, merchant_id: merchant.id)

    response = ItemsSerializer.item_index(2)

    expect(response[:data].length).to eq(1)
  end

  it '#item_index returns empty array for page with no data' do
    merchant = create(:merchant)
    create_list(:item, 21, merchant_id: merchant.id)

    response = ItemsSerializer.item_index(10)

    expect(response[:data]).to eq([])
  end

  it '#item_index has optional page length' do
    merchant = create(:merchant)
    create_list(:item, 100, merchant_id: merchant.id)

    response = ItemsSerializer.item_index(2, 50)

    expect(response[:data].length).to eq(50)
  end

  it '#item_show' do
    merchant = create(:merchant)
    create_list(:item, 39, merchant_id: merchant.id)
    item = Item.all.sample
    response = ItemsSerializer.item_show(item.id.to_s)

    expect(response[:data][:id]).to eq(item.id.to_s)
    expect(response[:data][:type]).to eq('item')
    expect(response[:data][:attributes][:name]).to eq(item.name)
    expect(response[:data][:attributes][:description]).to eq(item.description)
    expect(response[:data][:attributes][:unit_price]).to eq(item.unit_price)
    expect(response[:data][:attributes][:merchant_id]).to eq(item.merchant_id)
  end
end

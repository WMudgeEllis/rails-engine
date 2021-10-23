require "rails_helper"

RSpec.describe 'item api endpoints' do
  it 'can return a set of items' do
    merchant = create(:merchant)
    create_list(:item, 39, merchant_id: merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to be_a(Hash)
    expect(body[:data]).to be_a(Array)
    expect(body[:data][0][:attributes]).to be_a(Hash)
  end

  it 'can return by page' do
    merchant = create(:merchant)
    create_list(:item, 39, merchant_id: merchant.id)

    get '/api/v1/items?page=2'

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body[:data].length).to eq(19)
    expect(body[:data].last[:attributes][:name]).to eq(Item.last.name)
  end

  it 'can return customized page length' do
    merchant = create(:merchant)
    create_list(:item, 39, merchant_id: merchant.id)


    get '/api/v1/items?per_page=39'

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body[:data].length).to eq(39)
  end

end

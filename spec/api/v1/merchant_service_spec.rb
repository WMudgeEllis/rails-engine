require "rails_helper"

RSpec.describe 'Merchant api services' do
  it 'can return a set of merchants' do
    create_list(:merchant, 39)
    get '/api/v1/merchants'

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to be_a(Hash)
    expect(body[:data]).to be_a(Array)
    expect(body[:data][0][:attributes]).to be_a(Hash)
  end

  it 'can return by page' do
    create_list(:merchant, 39)
    get '/api/v1/merchants?page=2'

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body[:data].length).to eq(19)
    expect(body[:data].last[:attributes][:name]).to eq(Merchant.last.name)
  end

  it 'can return customized page length' do
    create_list(:merchant, 39)

    get '/api/v1/merchants?per_page=39'

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body[:data].length).to eq(39)
  end

  it 'can return one merchant' do
    create_list(:merchant, 5)

    merchant = Merchant.last

    get "/api/v1/merchants/#{merchant.id}"

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to be_a(Hash)
    expect(body).to have_key(:data)
    expect(body[:data]).to be_a(Hash)
    expect(body[:data]).to have_key(:id)
    expect(body[:data][:id]).to eq("#{merchant.id}")
    expect(body[:data]).to have_key(:type)
    expect(body[:data][:type]).to be_a(String)
    expect(body[:data]).to have_key(:attributes)
    expect(body[:data][:attributes]).to be_a(Hash)
  end

  it 'can return a merchants items' do
    merchant = create(:merchant)
    create_list(:item, 5, merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to be_a(Hash)
    expect(body).to have_key(:data)
    expect(body[:data]).to be_a(Array)
    expect(body[:data].first).to have_key(:id)
    expect(body[:data].first[:id]).to be_a(String)
    expect(body[:data].first).to have_key(:type)
    expect(body[:data].first[:type]).to be_a(String)
    expect(body[:data].first).to have_key(:attributes)
    expect(body[:data].first[:attributes]).to be_a(Hash)


  end
end

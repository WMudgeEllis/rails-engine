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
end

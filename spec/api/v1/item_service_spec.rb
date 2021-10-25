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

  it 'can fetch a single item' do
    merchant = create(:merchant)
    create_list(:item, 39, merchant_id: merchant.id)
    item = Item.all.sample

    get "/api/v1/items/#{item.id}"

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to be_a(Hash)
    expect(body[:data]).to be_a(Hash)
    # expect(body[:data]).to have_key([:id])
    expect(body[:data][:id]).to be_a(String)
    # expect(body[:data]).to have_key([:type])
    expect(body[:data][:type]).to be_a(String)
    # expect(body[:data]).to have_key([:attributes])
    expect(body[:data][:attributes]).to be_a(Hash)
  end

  it 'can create an item' do
    merchant = create(:merchant)
    item_params = {
      "name": "value1",
      "description": "value2",
      "unit_price": 100.99,
      "merchant_id": merchant.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    expect(response.status).to eq(201)

    body = JSON.parse(response.body, symbolize_names: true)
    item = Item.last

    expect(body[:data][:id]).to eq(item.id.to_s)
    expect(body[:data][:type]).to eq('item')
    expect(body[:data][:attributes][:name]).to eq(item.name)
    expect(body[:data][:attributes][:description]).to eq(item.description)
    expect(body[:data][:attributes][:unit_price]).to eq(item.unit_price)
    expect(body[:data][:attributes][:merchant_id]).to eq(item.merchant_id)
  end

  it 'can return an error if any attribute is missing' do
    merchant = create(:merchant)
    item_params = {
      "name": "value1",
      "description": "value2",
      "merchant_id": merchant.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to eq({:error=>"Unit price can't be blank"})
  end

  it 'ignores superfluous attributes' do
    merchant = create(:merchant)
    item_params = {
      "name": "value1",
      "description": "value2",
      "unit_price": 100.99,
      "merchant_id": merchant.id,
      "Extra, Extra": "Read all about it!"
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    item = Item.last

    expect(item.name).to eq(item_params[:name])
  end

  it 'can update an item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    item_params = {
      "name": "value1",
      "description": "value2",
      "unit_price": 100.99
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to be_successful

    new_item = Item.last
    expect(new_item.name).to eq(item_params[:name])

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body[:data][:id]).to eq(new_item.id.to_s)
    expect(body[:data][:type]).to eq('item')
    expect(body[:data][:attributes][:name]).to eq(new_item.name)
    expect(body[:data][:attributes][:description]).to eq(new_item.description)
    expect(body[:data][:attributes][:unit_price]).to eq(new_item.unit_price)
  end

  it 'find an items merchant' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

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

  it 'can delete an item' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id)
    item2 = create(:item, merchant_id: merchant.id)
    customer = create(:customer)
    invoice1 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    invoice2 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    item1.invoices << invoice1
    item1.invoices << invoice2
    item2.invoices << invoice2

    delete "/api/v1/items/#{item1.id}"

    expect(response.status).to eq(204)

    expect(Item.all).to eq([item2])
    expect(Invoice.all).to eq([invoice2])
  end

  it 'can search for an item by name' do
    merchant = create(:merchant)
    create_list(:item, 10, merchant_id: merchant.id)
    item = create(:item, name: 'Westons awesome item', merchant_id: merchant.id)

    get '/api/v1/items/find?name=West'

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to be_a(Hash)
    expect(body).to have_key(:data)
    expect(body[:data]).to be_a(Hash)
    expect(body[:data]).to have_key(:id)
    expect(body[:data][:id]).to eq(item.id.to_s)
    expect(body[:data]).to have_key(:type)
    expect(body[:data][:type]).to be_a(String)
    expect(body[:data]).to have_key(:attributes)
    expect(body[:data][:attributes]).to be_a(Hash)
    expect(body[:data][:attributes][:name]).to eq(item.name)
  end

  it 'can search for an item by min price' do
    merchant = create(:merchant)
    create_list(:item, 10, merchant_id: merchant.id)
    item = create(:item, unit_price: 200, merchant_id: merchant.id)

    get '/api/v1/items/find?min_price=100.1'

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body[:data][:id]).to eq(item.id.to_s)
  end

  it 'can search for an item by max price' do
    merchant = create(:merchant)
    create_list(:item, 10, merchant_id: merchant.id)
    item = create(:item, unit_price: 6, merchant_id: merchant.id)

    get '/api/v1/items/find?max_price=9'

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body[:data][:id]).to eq(item.id.to_s)
  end
end

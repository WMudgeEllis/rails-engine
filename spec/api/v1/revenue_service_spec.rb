require 'rails_helper'

RSpec.describe 'revenue endpoints' do
  before :each do
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)
    @customer = create(:customer)
    @item1 = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)
    @item3 = create(:item, merchant_id: @merchant2.id)
    @invoice = create(:invoice, customer_id: @customer.id, merchant_id: @merchant.id, status: 'shipped')
    @invoice2 = create(:invoice, customer_id: @customer.id, merchant_id: @merchant2.id, status: 'shipped')
    @invoice3 = create(:invoice, customer_id: @customer.id, merchant_id: @merchant2.id, status: 'not shipped')
    @invoice4 = create(:invoice, customer_id: @customer.id, merchant_id: @merchant2.id, status: 'not shipped')
    create(:transaction, invoice_id: @invoice.id)
    create(:transaction, invoice_id: @invoice2.id)
    create(:transaction, invoice_id: @invoice3.id)
    create(:transaction, invoice_id: @invoice4.id)
    create(:invoice_item, item_id: @item1.id, invoice_id: @invoice.id, quantity: 10, unit_price: 1.0)
    create(:invoice_item, item_id: @item2.id, invoice_id: @invoice.id, quantity: 2, unit_price: 2.2)
    create(:invoice_item, item_id: @item3.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 1)
    create(:invoice_item, item_id: @item3.id, invoice_id: @invoice3.id, quantity: 1, unit_price: 1)
    create(:invoice_item, item_id: @item3.id, invoice_id: @invoice4.id, quantity: 1, unit_price: 1)
  end

  it 'can return a merchants revenue' do
    get "/api/v1/revenue/merchants/#{@merchant.id}"

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)
    expect(body[:data]).to have_key(:id)
    expect(body[:data][:id]).to be_a(String)
    expect(body[:data]).to have_key(:type)
    expect(body[:data][:type]).to be_a(String)
    expect(body[:data]).to have_key(:attributes)
    expect(body[:data][:attributes]).to be_a(Hash)
    expect(body[:data][:attributes]).to have_key(:revenue)
    expect(body[:data][:attributes][:revenue]).to be_a(Float)
  end

  it 'can return merchants in order of revenue' do
    get '/api/v1/revenue/merchants?quantity=2'

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)
    expect(body[:data]).to be_a(Array)
    expect(body[:data].length).to eq(2)
    expect(body[:data][0]).to have_key(:id)
    expect(body[:data][0][:id]).to be_a(String)
    expect(body[:data][0]).to have_key(:type)
    expect(body[:data][0][:type]).to be_a(String)
    expect(body[:data][0]).to have_key(:attributes)
    expect(body[:data][0][:attributes]).to be_a(Hash)
    expect(body[:data][0][:attributes]).to have_key(:revenue)
    expect(body[:data][0][:attributes][:revenue]).to be_a(Float)
  end

  it 'requires a param for top merchants' do
    get '/api/v1/revenue/merchants'

    expect(response.status).to eq(400)
  end

  it 'can get revenue of unshipped orders' do
    create_list(:item, 10, merchant_id: @merchant.id)

    get '/api/v1/revenue/unshipped?quantity=2'

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)
    expect(body[:data]).to be_a(Array)
    expect(body[:data].length).to eq(2)
    expect(body[:data][0]).to have_key(:id)
    expect(body[:data][0][:id]).to be_a(String)
    expect(body[:data][0]).to have_key(:type)
    expect(body[:data][0][:type]).to be_a(String)
    expect(body[:data][0]).to have_key(:attributes)
    expect(body[:data][0][:attributes]).to be_a(Hash)
    expect(body[:data][0][:attributes]).to have_key(:potential_revenue)
    expect(body[:data][0][:attributes][:potential_revenue]).to be_a(Float)
  end

  it 'returns an error if quantity is 0 or less' do
    get '/api/v1/revenue/unshipped?quantity=0'

    expect(response).to_not be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:error)
  end

  it 'returns 400 when blank value' do
    get '/api/v1/revenue/unshipped?quantity='

    expect(response.status).to eq(400)
  end

  it 'can find items ranked by revenue' do
    get '/api/v1/revenue/items?quantity=3'

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to have_key(:data)
    expect(body[:data]).to be_a(Array)
    expect(body[:data].length).to eq(3)
    expect(body[:data][0]).to have_key(:id)
    expect(body[:data][0][:id]).to be_a(String)
    expect(body[:data][0]).to have_key(:type)
    expect(body[:data][0][:type]).to be_a(String)
    expect(body[:data][0]).to have_key(:attributes)
    expect(body[:data][0][:attributes]).to be_a(Hash)
    expect(body[:data][0][:attributes]).to have_key(:name)
    expect(body[:data][0][:attributes][:name]).to be_a(String)
    expect(body[:data][0][:attributes]).to have_key(:description)
    expect(body[:data][0][:attributes][:description]).to be_a(String)
    expect(body[:data][0][:attributes]).to have_key(:unit_price)
    expect(body[:data][0][:attributes][:unit_price]).to be_a(Float)
    expect(body[:data][0][:attributes]).to have_key(:merchant_id)
  end

  it 'defaults to 10' do
    items = create_list(:item, 10, merchant_id: @merchant.id)
    items.each { |item| create(:invoice_item, item_id: item.id, invoice_id: @invoice.id) }
    get '/api/v1/revenue/items'

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body[:data].length).to eq(10)
  end

  it 'returns 400 with bad params' do
    get '/api/v1/revenue/items?quantity='

    expect(response.status).to eq(400)

    get '/api/v1/revenue/items?quantity=-1'

    expect(response.status).to eq(400)

    get '/api/v1/revenue/items?quantity=adfhjsadfhjs'

    expect(response.status).to eq(400)
  end
end

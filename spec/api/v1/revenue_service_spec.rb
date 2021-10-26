require "rails_helper"

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
    create(:transaction, invoice_id: @invoice.id, result: 'success')
    create(:transaction, invoice_id: @invoice2.id, result: 'success')
    create(:invoice_item, item_id: @item1.id, invoice_id: @invoice.id, quantity: 10, unit_price: 1.0)
    create(:invoice_item, item_id: @item2.id, invoice_id: @invoice.id, quantity: 2, unit_price: 2.2)
    create(:invoice_item, item_id: @item3.id, invoice_id: @invoice.id, quantity: 2, unit_price: 2.2)
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
end

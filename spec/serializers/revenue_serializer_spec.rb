require "rails_helper"

RSpec.describe RevenueSerializer do


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
    create(:invoice_item, item_id: @item3.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 1)
  end

  it '#merchant_revenue' do
    allow_any_instance_of(Merchant).to receive(:total_revenue).and_return(14.4)
    response = RevenueSerializer.merchant_revenue(@merchant)

    expect(response[:data][:id]).to eq(@merchant.id.to_s)
    expect(response[:data][:type]).to eq('merchant_revenue')
    expect(response[:data][:attributes][:revenue]).to eq(14.4)
  end

  it '#most_revenue' do
    response = RevenueSerializer.most_revenue(2)
    require "pry"; binding.pry
    expect(response[:data].length).to eq(2)
    expect(response[:data][0][:id]).to eq(@merchant.id.to_s)
    expect(response[:data][0][:type]).to eq('merchant_name_revenue')
    expect(response[:data][0][:attributes][:name]).to eq(@merchant.name)
    expect(response[:data][0][:attributes][:revenue]).to eq(14.4)
  end
end

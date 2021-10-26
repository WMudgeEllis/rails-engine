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

  describe 'queries' do
    before :each do
      @merchant = create(:merchant)
      @customer = create(:customer)
      @item1 = create(:item, merchant_id: @merchant.id)
      @item2 = create(:item, merchant_id: @merchant.id)
      @invoice = create(:invoice, customer_id: @customer.id, merchant_id: @merchant.id, status: 'shipped')
      create(:transaction, invoice_id: @invoice.id, result: 'success')
      @ii = create(:invoice_item, item_id: @item1.id, invoice_id: @invoice.id, quantity: 10, unit_price: 1.0)
      @ii2 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice.id, quantity: 2, unit_price: 2.2)
    end

    it '#merchant_revenue' do
      allow_any_instance_of(Merchant).to receive(:total_revenue).and_return(14.4)
      response = MerchantsSerializer.merchant_revenue(@merchant)

      expect(response[:data][:id]).to eq(@merchant.id.to_s)
      expect(response[:data][:type]).to eq('merchant_revenue')
      expect(response[:data][:attributes][:revenue]).to eq(14.4)
    end
  end
end

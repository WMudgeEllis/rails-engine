require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  it 'can get invoice where it is the only item' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id)
    item2 = create(:item, merchant_id: merchant.id)
    customer = create(:customer)
    invoice1 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    invoice2 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    invoice3 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    item1.invoices << invoice1
    item1.invoices << invoice2
    item2.invoices << invoice2
    item1.invoices << invoice3

    expect(item1.invoices_only_item).to eq([invoice1, invoice3])
  end

  it 'can find an item by name' do
    merchant = create(:merchant)
    create_list(:item, 19, merchant_id: merchant.id)
    item = create(:item, merchant_id: merchant.id, name: 'Westons awesome item')

    expect(Item.name_search('West')).to eq(item)
  end

  it 'returns first alphabetical order if many are found' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id, name: 'Westons awesome item')
    item2 = create(:item, merchant_id: merchant.id, name: 'Alpha West')
    create_list(:item, 19, merchant_id: merchant.id)

    expect(Item.name_search('West')).to eq(item2)
  end

  it 'can search by min price' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id, unit_price: 900)
    create_list(:item, 19, merchant_id: merchant.id)

    expect(Item.min_price_search(100)).to eq(item)
  end

  it 'can search by max price' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id, unit_price: 5)
    create_list(:item, 19, merchant_id: merchant.id)

    expect(Item.max_price_search(9)).to eq(item)
  end

  it 'can return list of items with highest revenue' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    item2 = create(:item, merchant_id: merchant.id)
    item3 = create(:item, merchant_id: merchant.id)
    customer = create(:customer)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    invoice2 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    create(:transaction, invoice_id: invoice.id)
    create(:transaction, invoice_id: invoice2.id)

    create(:invoice_item, invoice_id: invoice.id, item_id: item.id, quantity: 1, unit_price: 1)
    create(:invoice_item, invoice_id: invoice.id, item_id: item2.id, quantity: 2, unit_price: 2)
    create(:invoice_item, invoice_id: invoice.id, item_id: item3.id, quantity: 3, unit_price: 1)
    create(:invoice_item, invoice_id: invoice2.id, item_id: item3.id, quantity: 3, unit_price: 1)

    expect(Item.most_revenue(2)).to eq([item3, item2])
    expect(Item.most_revenue(1)[0].revenue).to eq(6)
  end
end

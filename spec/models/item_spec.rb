require "rails_helper"

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
end

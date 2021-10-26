require "rails_helper"

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
  end

  it 'can find all merchants' do
    merchant1 = create(:merchant, name: 'Turing')
    merchant2 = create(:merchant, name: 'Ring world')
    create_list(:merchant, 10)
    expect(Merchant.find_all('ring')).to eq([merchant2, merchant1])
  end

  it 'can get total revenue' do
    merchant = create(:merchant)
    customer = create(:customer)
    item1 = create(:item, merchant_id: merchant.id)
    item2 = create(:item, merchant_id: merchant.id)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id, status: 'shipped')
    invoice2 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
    invoice3 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id, status: 'shipped')
    create(:transaction, invoice_id: invoice.id, result: 'success')
    create(:transaction, invoice_id: invoice.id, result: 'failed')
    create(:transaction, invoice_id: invoice2.id, result: 'success')
    create(:transaction, invoice_id: invoice3.id, result: 'failed')
    ii = create(:invoice_item, item_id: item1.id, invoice_id: invoice.id, quantity: 10, unit_price: 1.0)
    ii2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice.id, quantity: 2, unit_price: 2.2)
    ii3 = create(:invoice_item, item_id: item1.id, invoice_id: invoice2.id, quantity: 1000, unit_price: 1.0)
    ii4 = create(:invoice_item, item_id: item1.id, invoice_id: invoice3.id, quantity: 1, unit_price: 3.14159)

    expect(merchant.total_revenue).to eq(14.4)
  end
end

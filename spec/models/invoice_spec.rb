require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions) }

    it 'can return unshipped orders with potential_revenue' do
      merchant = create(:merchant)
      customer = create(:customer)
      item = create(:item, merchant_id: merchant.id)
      invoice1 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
      invoice2 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id, status: 'packaged')
      invoice3 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id, status: 'packaged')
      create(:transaction, invoice_id: invoice1.id)
      create(:transaction, invoice_id: invoice2.id)
      create(:transaction, invoice_id: invoice3.id)
      create(:invoice_item, item_id: item.id, invoice_id: invoice1.id, quantity: 1, unit_price: 10_000.0)
      create(:invoice_item, item_id: item.id, invoice_id: invoice2.id, quantity: 7, unit_price: 1.0)
      create(:invoice_item, item_id: item.id, invoice_id: invoice3.id, quantity: 2, unit_price: 3.0)
      create(:invoice_item, item_id: item.id, invoice_id: invoice3.id, quantity: 1, unit_price: 3.0)

      expect(Invoice.unshipped_orders(2)).to eq([invoice3, invoice2])
      expect(Invoice.unshipped_orders(1)).to eq([invoice3])
      expect(Invoice.unshipped_orders(1).first.potential_revenue).to eq(9.0)
    end
  end
end

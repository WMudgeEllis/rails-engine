class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions


  def self.unshipped_orders(num_results = 10)
    self.joins(:invoice_items, :transactions)
        .where(transactions: { result: 'success' })
        .where.not(invoices: {status: 'shipped'})
        .select('invoices.*, SUM(quantity * unit_price) AS potential_revenue')
        .group('invoices.id')
        .order(potential_revenue: :desc)
        .limit(num_results)
  end
end

class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices


  def self.find_all(name)
    where('lower(name) LIKE ?', "%#{name.downcase}%").order(:name)
  end

  def total_revenue
    invoices.joins(:transactions, :invoice_items)
            .where(transactions: {result: 'success'})
            .where(invoices: {status: 'shipped'})
            .select('invoice_items.*')
            .sum('unit_price * quantity')
  end
end

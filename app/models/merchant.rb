class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices


  def self.find_all(name)
    where('lower(name) LIKE ?', "%#{name.downcase}%").order(:name)
  end

  def total_revenue
    invoice_items = invoices.where(status: 'shipped')
                            .joins(:transactions)
                            .where(transactions: {result: 'success'})
                            .joins(:invoice_items)
                            .select('invoice_items.*')
    invoice_items.sum do |invoice_item|
       invoice_item.quantity * invoice_item.unit_price
     end
  end
end

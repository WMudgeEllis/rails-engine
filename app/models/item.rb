class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true

  def invoices_only_item
    invoices.joins(:invoice_items)
            .select('invoices.*')
            .group('invoices.id')
            .having('COUNT(*) = 1')
  end

  def self.name_search(name)
    where('lower(name) LIKE ?', "%#{name.downcase}%")
      .order(:name).first
  end

  def self.min_price_search(min_price)
    where('unit_price > ?', min_price).order(:name).first
  end

  def self.max_price_search(max_price)
    where('unit_price < ?', max_price).order(:name).first
  end

  def self.most_revenue(num_results = 10)
    num_results ||= 10
    joins(:invoices, invoices: :transactions)
      .where(transactions: { result: :success })
      .where(invoices: { status: :shipped })
      .select('items.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue')
      .group('items.id')
      .order(revenue: :desc)
      .limit(num_results)
  end
end

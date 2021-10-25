class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true

  def invoices_only_item
    id_num_items = invoices.joins(:invoice_items).group('invoice_items.invoice_id').count
    ids = []
    id_num_items.each do |key, value|
      ids << key if value == 1
    end
    Invoice.find(ids)
  end
end

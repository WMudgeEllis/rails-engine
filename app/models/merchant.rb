class Merchant < ApplicationRecord
  has_many :items


  def self.find_all(name)
    where('lower(name) LIKE ?', "%#{name.downcase}%").order(:name)
  end

  def total_revenue

  end
end

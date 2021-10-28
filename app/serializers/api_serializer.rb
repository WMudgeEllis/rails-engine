class ApiSerializer
  def self.format_item(item)
    {
      id: item.id.to_s,
      type: 'item',
      attributes: {
        name: item.name,
        description: item.description,
        unit_price: item.unit_price,
        merchant_id: item.merchant_id
      }
    }
  end

  def self.format_merchant(merchant)
    {
      id: merchant.id.to_s,
      type: 'merchant',
      attributes: {
        name: merchant.name
      }
    }
  end
end

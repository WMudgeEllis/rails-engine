class RevenueSerializer < ApiSerializer

  def self.merchant_revenue(merchant)
    {
      data: {
        id: merchant.id.to_s,
        type: 'merchant_revenue',
        attributes: {
          revenue: merchant.total_revenue
        }
      }
    }
  end

  def self.most_revenue(num_results)
    merchants = Merchant.top_merchants(num_results)
    {
      data: merchants.map do |merchant|
          {
            id: merchant.id.to_s,
            type: 'merchant_name_revenue',
            attributes: {
              name: merchant.name,
              revenue: merchant.revenue
            }
          }
      end
    }
  end

  def self.unshipped_revenue(num_results)
    invoices = Invoice.unshipped_orders(num_results)
    {
      data: invoices.map do |invoice|
        {
          id: invoice.id.to_s,
          type: 'unshipped_order',
          attributes:{
            potential_revenue: invoice.potential_revenue
          }
        }
      end
    }
  end

  def self.item_revenue_list(num_results)
    items = Item.most_revenue(num_results)
    {
      data: items.map do |item|
        {
          id: item.id.to_s,
          type: 'item_revenue',
          attributes: {
            name: item.name,
            description: item.description,
            unit_price: item.unit_price,
            merchant_id: item.merchant_id,
            revenue: item.revenue

          }
        }
      end
    }
  end
end

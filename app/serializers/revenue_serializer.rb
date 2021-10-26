class RevenueSerializer

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
    api = { data: [] }
    merchants = Merchant.top_merchants(num_results)
    merchants.each do |merchant|
      api[:data] << {
        id: merchant.id.to_s,
        type: 'merchant_name_revenue',
        attributes: {
          name: merchant.name,
          revenue: merchant.revenue
        }
      }
    end
    api
  end
end

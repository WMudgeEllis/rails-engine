class MerchantsSerializer

  def self.merchant_index(page = 1)
    api = { data: [] }
    merchants = Merchant.all[0..19]
    merchants.flat_map do |merchant|
      api[:data] << {
        id: merchant.id,
        type: 'merchant',
        attributes: { name: merchant.name }
      }
    end
    api
  end

end

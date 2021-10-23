class MerchantsSerializer

  def self.merchant_index(page = nil, per_page = nil)
    #move to model or other methods? APISerializer superclass?
    page ||= 1
    per_page ||= 20
    page_index = (page -1) * per_page
    api = { data: [] }
    merchants = Merchant.limit(per_page)
    merchants = Merchant.all[page_index..page_index + per_page -1] if page > 1
    ##
    return api if merchants.nil?
    merchants.each do |merchant|
      #turn into merchant poro?
      api[:data] << {
        id: "#{merchant.id}",
        type: 'merchant',
        attributes: { name: "#{merchant.name}" }
      }
    end
    api
  end

end

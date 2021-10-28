class MerchantsSerializer < ApiSerializer

  def self.merchant_index(page = nil, per_page = nil)
    page ||= 1
    per_page ||= 20
    page_index = (page -1) * per_page
    api = { data: [] }
    merchants = Merchant.limit(per_page)
    merchants = Merchant.all[page_index..page_index + per_page -1] if page > 1
    return api if merchants.nil?
    merchants.each { |merchant| api[:data] << format_merchant(merchant) }
    api
  end

  def self.merchant_show(merchant_id)
    merchant = Merchant.find(merchant_id)
     {
       data: format_merchant(merchant)
     }
  end

  def self.merchant_items(merchant_id)
    merchant = Merchant.find(merchant_id)
    items = merchant.items
    {
      data: items.map { |item| format_item(item) }
    }
  end

  def self.merchant_find(name)
    merchants = Merchant.find_all(name)
    {
      data: merchants.map { |merchant| format_merchant(merchant) }
    }
  end
end

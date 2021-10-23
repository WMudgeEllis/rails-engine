class ItemsSerializer

  def self.item_index(page = nil, per_page = nil)
    page ||= 1
    per_page ||= 20
    page_index = (page -1) * per_page
    api = { data: [] }
    items = Item.limit(per_page)
    items = Item.all[page_index..page_index + per_page -1] if page > 1
    return api if items.nil?
    items.each do |item|
      api[:data] << {
        id: "#{item.id}",
        type: 'item',
        attributes: {
          name: item.name,
          description: item.description,
          unit_price: item.unit_price,
          merchant_id: item.merchant_id
         }
      }
    end
    api
  end


end

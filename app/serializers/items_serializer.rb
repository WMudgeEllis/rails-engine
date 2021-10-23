class ItemsSerializer < ApiSerializer

  def self.item_index(page = nil, per_page = nil)
    page ||= 1
    per_page ||= 20
    page_index = (page -1) * per_page
    api = { data: [] }
    items = Item.limit(per_page)
    items = Item.all[page_index..page_index + per_page -1] if page > 1
    return api if items.nil?
    items.each { |item| api[:data] << format_item(item) }
    api
  end

  def self.item_show(item_id)
    item = Item.find(item_id)
    { data: format_item(item) }
  end

end

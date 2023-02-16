module Common::Helpers::PageMetaHelper
  def page_meta(collection, options={})
    response.headers['current-page'] = options[:page] || @page
    response.headers['items-per-page'] = options[:per_page] || @per_page
    response.headers['last-page'] = options[:total_pages] || (collection.present? ? collection.total_pages : 0)
    response.headers['total-items'] = options[:total_records] || (collection.present? ? collection.total_count : 0)
    {
      total_records: options[:total_records] || (collection.present? ? collection.total_count : 0),
      total_pages: options[:total_pages] || (collection.present? ? collection.total_pages : 0),
      page: (options[:page] || @page),
      per_page: (options[:per_page] || @per_page)
    }
  end

  def get_page(page)
    page.to_i <= 0 ? 1 : page.to_i
  end

  def get_per_page(per_page)
    pages = [10, 50, 100, 200]
    pages.include?(per_page.to_i) ? per_page.to_i : 10
  end
end

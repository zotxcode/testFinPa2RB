class ProductsSpider < Kimurai::Base
  @name = 'products_spider'
  @engine = :mechanize

  def self.process()
    @start_urls = ["https://magento-test.finology.com.my/"]
    begin
      self.crawl!
    rescue
      link = Link.find_by_visited(false)
      if link 
        link.update_column('visited', true)
        self.process(link.href)
      end
      
    end
  end

  def parse(response, url:, data: {})
      item = {}
      item[:url] = url
      item[:name] = response.xpath('.//*[@class="product-info-main"]//*[@class="page-title"]//span')&.text&.squish
      item[:price] = response.xpath('.//*[@class="product-info-price"]//*[@data-price-type="finalPrice"]//span')&.text&.squish&.delete('^[0-9]*\.?[0-9]').to_f.round(2)
      item[:description] = response.xpath('.//*[@class="product attribute description"]//p')&.text&.squish

      extra_info = []
      response.xpath('.//*[@id="product-attribute-specs-table"]//tr').each do |tbl|
        extra_info << tbl.css('th')&.text&.squish + ": " + tbl.css('td')&.text&.squish
      end
      item[:extra_information] = extra_info.join(" | ")
      if !item[:name].strip.empty?  
        Product.where(item).first_or_create
      end

      response.xpath('//a').each do |a|
        no_params = a[:href].split("?")[0] rescue a[:href]
        item = {:href => absolute_url(no_params, base: url), visited: false }
        Link.create(item) if !Link.find_by_href(item[:href])
      end

      Link.where(visited: false).each do |a|
        a.update_column('visited', true)
        request_to :parse, url: a.href
      end
  end

end
module Jekyll
  class Pagination
    def paginate(site, page)
      all_posts = site.site_payload['site']['posts']
      all_posts = all_posts.reverse
      all_posts_size = all_posts.size
      pages = Pager.calculate_pages(all_posts, site.config['paginate'].to_i)
      (1..pages).sort.reverse.each do |num_page|
        pager = MyPager.new(site.config, num_page, all_posts, pages)
        newpage = Page.new(site, site.source, page.dir, page.name)
        newpage.pager = pager
        newpage.dir = File.join(page.dir, "page#{num_page}")
        site.pages << newpage

        #
        # The last page is the total pages minus one
        if num_page == pages
          page.pager = pager
        end
      end
    end
  end

  class MyPager < Pager
    def initialize(config, page, all_posts, num_pages = nil)
      super config, page, all_posts, num_pages
      @posts.reverse!
    end
  end
end

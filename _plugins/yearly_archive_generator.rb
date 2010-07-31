module TravisSwicegoodGenerators
  class YearlyArchivePage < Jekyll::Page
    attr_accessor :posts

    def initialize(site, year, posts)
      @site = site
      @layout = "yearly_archive"
      @posts = posts
      @year = year
      @dir = ''
      @url = "/#{@year}/"
      @name = "#{@url}index.html"
      halt_on_layout_error unless layout_available?
    end

    def layout_available?
      @site.layouts.include? @layout
    end

    def data
      {
        "layout" => @layout,
        "posts" => @posts,
        "url" => @url,
        "year" => @year,
      }
    end

    def to_liquid
      data
    end

    def halt_on_layout_error
      $stderr.puts "
Hold your horses!  yearly_archive_generator plugin, here.

You've enabled me but haven't added a yearly_archive layout.
At least put an empty file there or I'm not going to run.
"
      exit(-1)
    end

    def read_yaml(base, name)
      # Don't need to do anything but satisfy Jekyll's contract
    end

    def to_liquid
      self.data
    end

  end

  class YearlyArchiveGenerator < Jekyll::Generator
    def initialize(config = {})
      super(config)
      @yearly_buckets = {}
    end

    def generate(site)
      @site = site
      site.posts.dup.each { |post| add_to_yearly_bucket(post) }
      process
    end

    def add_to_yearly_bucket(post)
      @yearly_buckets[post.date.year] = [] if @yearly_buckets[post.date.year].nil?
      @yearly_buckets[post.date.year] << post
    end

    def process
      @yearly_buckets.each_pair do |year, posts|
        posts.sort! { |a,b| b.date <=> a.date }
        @site.pages << YearlyArchivePage.new(@site, year, posts)
      end
    end
  end
end

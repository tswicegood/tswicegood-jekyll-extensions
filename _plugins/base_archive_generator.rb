module TravisSwicegoodGenerators
  class BaseArchivePage < Jekyll::Page
    def initialize(site, posts)
      if @layout.nil?
        @layout = "%s_archive" % self.class.to_s.split('::').last.to_s.sub('ArchivePage', '').downcase
      end
      @site = site
      @posts = posts
      @dir = ''
      @name = "#{@url}index.html"
      halt_on_layout_error unless layout_available?
    end

    def to_liquid
      data
    end

    def read_yaml(base, name)
      # Don't need to do anything but satisfy Jekyll's contract
    end

    def layout_available?
      @site.layouts.include? @layout
    end

    def data
      {
        "layout" => @layout,
        "posts" => @posts,
        "url" => @url,
      }
    end

    def halt_on_layout_error
      $stderr.puts self.layout_err_msg
      exit(-1)
    end
  end

  module ArchiveGenerator
    def default_bucket
      {:posts => [], :subs => {}}
    end

    def initialize(config = {})
      super(config)
      @bucket = {}
    end

    def generate(site)
      @site = site
      site.posts.dup.each { |post| add_to_bucket(post) }
      process
    end

  end
end

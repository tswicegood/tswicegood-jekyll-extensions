module TravisSwicegoodGenerators
  class CommonTagAchive < Jekyll::Page
    attr_reader :name, :subs, :tag_name, :tags, :real_init
    attr_accessor :layouts, :posts, :data

    def initialize(site, tag_name)
      real_init site, tag_name
      halt_on_layout_error unless layout_available?
    end

    def real_init(site, tag_name)
      # required for Jekyll
      @layout = "tag_archive"
      @dir = ''
      @tag_name = tag_name
      @name = "#{@url}index.html"

      @site = site
      @posts = []
      @subs = {}
      # TODO: TagArchiveList objects should have a parent capability
      @sub_list = TagArchiveList.new(@site)
    end

    # TODO: refactor this code into a common module
    def layout_available?
      if !@_layout_available
        @_layout_available = @site.layouts.include? @layout
      end
      @_layout_available
    end

    def halt_on_layout_error
      $stderr.puts "Please add a #{@layout} file to your _layouts/ directory"
      exit(-1)
    end

    def read_yaml(base, name)
      # Don't need to do anything but satisfy Jekyll's contract
    end

    # END common code

    def to_liquid
      self.data
    end

    def data
      {
        "title" => "Posts tagged with \"#{@tag_name}\" on TravisSwicegood.com",
        "layout" => @layout,
        "posts" => @posts,
        "url" => @url,
        "tag_name" => @tag_name,
        "tags" => [@tag_name, ],
      }
    end

    def url
      "/tags/#{@tag_name}/"
    end

    def count
      @posts.length
    end

    def tags
      @sub_list.tags
    end

    def add(post)
      @posts << post
      categories_left = post.categories - [@tag_name]
      return if categories_left.empty?

      paired_down_post = post.dup
      paired_down_post.categories = categories_left
      @sub_list.add paired_down_post
    end
  end

  class TagArchiveAtomPage < CommonTagAchive
    def real_init(site, tag_name)
      super(site, tag_name)
      @layout = "tag_archive_atom"
    end

    def url
      "#{super()}atom/"
    end
  end

  class TagArchivePage < CommonTagAchive
  end

  class TagArchiveList
    attr_accessor :tags
    def initialize(site)
      @site = site
      @tags = {}
    end

    def add(post)
      post.categories.each do |category|
        @tags[category] ||= TagArchivePage.new(@site, category)
        @tags["#{category}_atom"] ||= TagArchiveAtomPage.new(@site, category)
        @tags[category].add post
        @tags["#{category}_atom"].add post
      end
    end

  end

  class TagArchiveGenerator < Jekyll::Generator
    def initialize(config = {})
      super(config)
    end

    def generate(site)
      @site = site
      @list = TagArchiveList.new(site)
      @site.posts.dup.each { |post| @list.add post }
      process
    end

    def process()
      @list.tags.values.each do |page|
        # TODO: process all of the sub tags and generate pages for them as well
        @site.pages << page
      end
    end
  end

end


module TravisSwicegoodGenerators
  class YearlyArchivePage < BaseArchivePage
    attr_accessor :posts

    def layout_err_msg
      "
Hold your horses!  yearly_archive_generator plugin, here.

You've enabled me but haven't added a yearly_archive layout.
At least put an empty file there or I'm not going to run.

Missing file:
  %s/%s.html
" % ["_layouts", @layout]
    end

    def initialize(site, year, posts)
      @year = year
      @url = "/%04d/" % [@year]
      super site, posts
    end

    def data
      super.deep_merge({
        "year" => @year,
      })
    end
  end

  class YearlyArchiveGenerator < Jekyll::Generator
    include ArchiveGenerator

    def add_to_bucket(post)
      @bucket[post.date.year] ||= default_bucket
      @bucket[post.date.year][:posts] << post
    end

    def process
      @bucket.each_pair do |year, data|
        posts = data[:posts]
        posts.sort! { |a,b| b.date <=> a.date }
        @site.pages << YearlyArchivePage.new(@site, year, posts)
      end
    end
  end
end

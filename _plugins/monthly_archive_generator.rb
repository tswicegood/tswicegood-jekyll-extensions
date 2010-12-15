module TravisSwicegoodGenerators
  class MonthlyArchivePage < BaseArchivePage
    attr_accessor :posts

    def layout_err_msg
      "
Hold your horses!  monthly_archive_generator plugin, here.

You've enabled me but haven't added a monthly_archive layout.
At least put an empty file there or I'm not going to run.

Missing file:
  %s/%s.html
" % ["_layouts", @layout]
    end

    def initialize(site, year, month, posts)
      @year = year
      @month = month
      @url = "/%04d/%02d/" % [@year, @month]
      super(site, posts)
    end

    def data
      super.deep_merge({
        "year" => @year,
        "month" => @month,
      })
    end
  end

  class MonthlyArchiveGenerator < Jekyll::Generator
    include ArchiveGenerator

    def add_to_bucket(post)
      @bucket[post.date.year] ||= default_bucket
      @bucket[post.date.year][:subs][post.date.month] ||= default_bucket
      @bucket[post.date.year][:subs][post.date.month][:posts] << post
    end

    def process
      @bucket.each_pair do |year, months|
        months[:subs].each_pair do |month, data|
          posts = data[:posts]
          posts.sort! { |a,b| b.date <=> a.date }
          @site.pages << MonthlyArchivePage.new(@site, year, month, posts)
        end
      end
    end
  end
end

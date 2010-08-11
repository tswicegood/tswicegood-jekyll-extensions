module TravisSwicegoodGenerators
  class DailyArchivePage < BaseArchivePage
    attr_accessor :posts

    def layout_err_msg
      "
Hold your horses!  daily_archive_generator plugin, here.

You've enabled me but haven't added a daily_archive layout.
At least put an empty file there or I'm not going to run.

Missing file:
  %s/%s.html
" % ["_layouts", @layout]
    end

    def initialize(site, year, month, day, posts)
      @year = year
      @month = month
      @day = day
      @url = "/%04d/%02d/%02d/" % [@year, @month, @day]
      super(site, posts)
    end

    def data
      super.deep_merge({
        "year" => @year,
        "month" => @month,
        "day" => @day,
      })
    end
  end

  class DailyArchiveGenerator < Jekyll::Generator
    include ArchiveGenerator

    def add_to_bucket(post)
      @bucket[post.date.year] ||= default_bucket
      @bucket[post.date.year][:subs][post.date.month] ||= default_bucket
      @bucket[post.date.year][:subs][post.date.month][:subs][post.date.day] ||= default_bucket
      @bucket[post.date.year][:subs][post.date.month][:subs][post.date.day][:posts] << post
    end

    def process
      @bucket.each_pair do |year, monthly_data|
        monthly_data[:subs].each_pair do |month, daily_data|
          daily_data[:subs].each_pair do |day, data|
            posts = data[:posts]
            posts.sort! { |a,b| b.date <=> a.date }
            @site.pages << DailyArchivePage.new(@site, year, month, day, posts)
          end
        end
      end
    end
  end
end

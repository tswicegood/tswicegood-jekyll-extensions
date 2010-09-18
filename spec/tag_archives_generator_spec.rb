require "jekyll"
require "./_plugins/tag_archives_generator.rb"

class DumbPost
  attr_accessor :categories, :site
end

def mock_site
  site = mock('Site')
  hash = mock()
  hash.stub!(:include?).and_return(true)
  site.stub!(:layouts).and_return(hash)
  site
end

module TravisSwicegoodGenerators
  describe TagArchivePage, "" do
    before(:each) do
      @site = mock_site
    end

    it "is a Jekyll::Page" do
      TagArchivePage.is_a? Jekyll::Page
    end

    describe "Layout" do
      it "should throw an exception if the layout does not exist" do
        site = mock('Site')
        hash = mock()
        hash.stub!(:include?).and_return(false)
        site.stub!(:layouts).and_return(hash)

        lambda { TagArchivePage.new(site, "foo") }.should raise_error SystemExit
      end
    end

    describe "Creation of a simple page with one tag" do
      before(:each) do
        @site = mock_site
        @post = mock('Post')
        @post.stub!(:site).and_return(@site)
        @post.stub!(:categories).and_return(["foo"])
      end

      it "should contain a posts property with only the original post" do
        t = TagArchivePage.new(@site, "foo")
        t.add @post
        t.posts.should == [@post]
      end

      it "should contain a tag_name property of the original tag name" do
        t = TagArchivePage.new(@site, "foo")
        t.add @post
        t.tag_name.should == 'foo'
      end

      it "should contain an empty `tags` property" do
        t = TagArchivePage.new(@site, "foo")
        t.add @post
        t.tags.should == {}
      end
    end

    describe "Creation of a page with three tags" do
      before(:each) do
        @site = mock_site
        @post = DumbPost.new()
        @post.site = @site
        @post.categories = ['foo', 'bar', 'baz']
      end

      it "should contain an empty posts property by default" do
        t = TagArchivePage.new(@site, "foo")
        t.posts.should == []
      end

      it "should contain a posts property with only the original post" do
        t = TagArchivePage.new(@site, "foo")
        t.add @post
        t.posts.should == [@post]
      end

      it "should contain a name property of the original tag name" do
        t = TagArchivePage.new(@site, "foo")
        t.add @post
        t.tag_name.should == 'foo'
      end

      it "should contain an `tags` property with the other tags" do
        t = TagArchivePage.new(@site, "foo")
        t.add @post
        t.tags.length.should == 2
        ["bar", "baz"].each {|a| t.tags.include?(a).should be true }
      end

      describe "tags should also contain" do
        before(:each) do
          @t = TagArchivePage.new(@site, "foo")
          @t.add @post
        end

        it "one other tag each" do
          @t.tags['bar'].tags.length.should == 1
          @t.tags['baz'].tags.length.should == 1
        end

        it "one post each" do
          @t.tags['bar'].count.should == 1
          @t.tags['baz'].count.should == 1
        end
      end

      describe "bar" do
        it "should contain another tags containing baz" do
          t = TagArchivePage.new(@site, "foo")
          t.add @post
          t.tags['bar'].tags.length.should == 1
          t.tags['bar'].tags.include?('baz').should be true
        end
      end

      describe "baz" do
        it "should contain another tags containing bar" do
          t = TagArchivePage.new(@site, "foo")
          t.add @post
          t.tags['baz'].tags.length.should == 1
          t.tags['baz'].tags.include?('bar').should be true
        end
      end
    end

    describe "url param" do
      it "should be prefixed by /tags/" do
        t = TagArchivePage.new(@site, "foo")
        t.url[0..5].should == "/tags/"
      end

      it "should be /tags/<tag_name>/" do
        t = TagArchivePage.new(@site, "foo")
        t.url.should == "/tags/foo/"
      end
    end
  end

  describe TagArchiveList, "is a list of all top-level tags" do
    CATEGORIES = [
      ["php", "opensource"],
      ["php", "python", "ruby"],
      ["ruby", "python"],
      ["political", "government"],
      ["opensource", "government"],
    ]
    before(:each) do
      @site = mock_site()
      @posts = []
      5.times do |i|
        post = DumbPost.new
        post.site = @site
        post.categories = CATEGORIES[i]
        @posts << post
      end

      @list = TagArchiveList.new @site
      @posts.each {|p| @list.add p }
    end

    it "should contain a list of all tags from all posts" do
      @list.tags.length.should == 6
    end

    describe "the PHP tag should have a subtag of" do
      it "an opensource tag with one post" do
        @list.tags['php'].tags['opensource'].count.should == 1
      end

      it "a python tag with one post" do
        @list.tags['php'].tags['python'].count.should == 1
      end

      it "a ruby tag with one post" do
        @list.tags['php'].tags['ruby'].count.should == 1
      end

      it "and the python and ruby tags should be the same post" do
        python_post = @list.tags['php'].tags['python'].posts[0]
        ruby_post = @list.tags['php'].tags['ruby'].posts[0]
        python_post.should == ruby_post
      end
    end

    describe "the python tag" do
      it "should have two posts" do
        @list.tags['python'].count.should == 2
      end

      describe "should have the sub tag:" do
        it "ruby that has two posts" do
          @list.tags['python'].tags.include?("ruby").should be true
          @list.tags['python'].tags['ruby'].count.should be 2
        end

        it "php that has one post" do
          @list.tags['python'].tags.include?("php").should be true
          @list.tags['python'].tags['php'].count.should be 1
        end
      end
    end

  end
end


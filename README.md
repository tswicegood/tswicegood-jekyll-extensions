My Jekyll Extensions & Plugins
==============================

A small collection of extension and plugins built on top of the [jekyll_ext][]
and the internal [jekyll][] plugin system for use with [jekyll][].

*NOTE*: This repo is in flux continually.  It's a great place to learn as the
plugins and extensions are simple, but proceed with caution before using.

*Planned Changes*: After starting down the path of [jekyll_ext][] I found out
that [jekyll][] has added a plug-in architecture.  My goal is to refactor the
b2evo_urls to use this architecture and remove the need for anything other than
jekyll.

Installation & Usage
--------------------
There are two parts to this (I hope to get them all down to just plugins).

### Installing Jekyll Extensions
If you plan on using any of the extensions that are in directories other than
the `_plugins/` directory, you need to follow these instructions:

* Make sure you have [jekyll_ext][] installed (`gem install jeykll_ext` should
get you going)
* Clone this repository
* Copy the extensions you want to use from it into the `_extensions/` directory
in your jekyll project
* Run `ejekyll` to generate your site

#### Installation as a git submodule

I use this as a submodule on my sites.  Here's how I set it up (these commands
are run within the project):

    git submodule add git://github.com/tswicegood/tswicegood-jekyll-extensions \
        vendor/tswicegood-jekyll-extensions
    for i in $(ls -d vendor/tswicegood-jekyll-extensions/*/| grep -v _plugins); do
        ln -s ../`echo $i | sed -e 's/\/$//'` _extensions/
    done

### Installing Plugins
Copy and paste any of the `*.rb` files out of the `_plugins/` directory into
your own `_plugins/` directory, and you're set.  You can also symlink them a la
the code above if you like.

Included Extensions
-------------------

### b2evo_urls

Having run a blog for nearly 6 years, I've got a ton of incoming links to pages
all over the Intertubes.  Not killing them is important, so I want to translate
them all to their new homes.

Rather than using a [mod_rewrite][] rule and tying myself to [Apache][], I
decided to create a symlink structure inside a `/index.php/` directory that
matches my URL structure from b2evo.


Included Plugins
----------------

### reverse_pagenums

What sense does it make for our archives to be constantly changing.  The
contents of "page2" are always shifting as we add no content.  This isn't very
good for a RESTful process, so this reverses everything making sure that your
archive posts never go away.

Thanks to [James Tauber][] for the [idea][restful tweet].


### yearly_archive_generator

This adds `/:year/` pages that contain all of the posts from that year.

This plug-in expects a `_layouts/yearly_archive.html` file and will refuse to run
without it.

The following variables are passed in to it (in addition to the normal jekyll
variables):

* `page.posts`: An reverse-chronological array of all of the posts from the
  provided year.  These are full `post` variables with all the standard
  variables you've come to know and love.
* `page.url`: The URL for the page in question
* `page.year`: The year for the archive page being rendered


### monthly_archive_generator

This adds `/:year/:month/` pages that contain all of the posts from that month
and year.

This plug-in expects a `_layouts/monthly_archive.html` file and will refuse to
run without it.

This plug-in adds all of the variables from `yearly_archive_generator` and:

* `page.month'`: The month of the archive page being rendered


[jekyll_ext]: http://github.com/rfelix/jekyll_ext 
[jekyll]: http://github.com/mojombo/jekyll
[mod_rewrite]: http://httpd.apache.org/docs/2.2/mod/mod_rewrite.html
[Apache]: http://httpd.apache.org/
[James Tauber]: http://jtauber.com/
[restful tweet]: http://twitter.com/jtauber/status/19367584939

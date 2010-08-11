My Jekyll Plugins
=================

A small collection of extension and plugins built on top of the [jekyll][]'s
internal plugin system.

*NOTE*: This repo is in flux continually.  It's a great place to learn as the
plugins and extensions are simple, but proceed with caution before using.


Installation & Usage
--------------------
Copy and paste any of the `*.rb` files out of the `_plugins/` directory into
your own `_plugins/` directory, and you're set.  You can also symlink them a la
the code above if you like.


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


### daily_archive_generator

This adds `/:year/:month/:day/` pages that contain all of the posts from that
day, month, and year.

This plug-in expects a `_layouts/daily_archive.html` file and will refuse to
run without it.

This plug-in adds all of the variables from `monthly_archive_generator` and:

* `page.day'`: The day of the month of the archive page being rendered


[jekyll]: http://github.com/mojombo/jekyll
[mod_rewrite]: http://httpd.apache.org/docs/2.2/mod/mod_rewrite.html
[Apache]: http://httpd.apache.org/
[James Tauber]: http://jtauber.com/
[restful tweet]: http://twitter.com/jtauber/status/19367584939

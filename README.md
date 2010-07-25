My Jekyll Extensions
====================

A small collection of extension built on top of the [jekyll_ext][] package for
[jekyll][].


Installation & Usage
--------------------

* Make sure you have [jekyll_ext][] installed (`gem install jeykll_ext` should
get you going)
* Clone this repository
* Copy the extensions you want to use from it into the `_extensions/` directory
in your jekyll project
* Run `ejekyll` to generate your site


### Installation as a git submodule

I use this as a submodule on my sites.  Here's how I set it up (these commands
are run within the project):

    git submodule add git://github.com/tswicegood/tswicegood-jekyll-extensions \
        vendor/tswicegood-jekyll-extensions
    for i in $(ls -d vendor/tswicegood-jekyll-extensions/*/); do
        ln -s ../`echo $i | sed -e 's/\/$//'` _extensions/
    done


Included Extensions
-------------------

### b2evo_urls

Having run a blog for nearly 6 years, I've got a ton of incoming links to pages
all over the Intertubes.  Not killing them is important, so I want to translate
them all to their new homes.

Rather than using a [mod_rewrite][] rule and tying myself to [Apache][], I
decided to create a symlink structure inside a `/index.php/` directory that
matches my URL structure from b2evo.



[jekyll_ext]: http://github.com/rfelix/jekyll_ext 
[jekyll]: http://github.com/mojombo/jekyll
[mod_rewrite]: http://httpd.apache.org/docs/2.2/mod/mod_rewrite.html
[Apache]: http://httpd.apache.org/

# rack-bundle

A Rack middleware for grouping Javascripts into one single file. It also works for stylesheets, grouping them by media type.

# How does it work

It parses the response body using [Nokogiri](http://nokogiri.org/), finds every reference to external scripts/stylesheets, locates
them in the file system, bundles them, saves the bundle in the application's public directory, and replaces the references in the
response for one single reference to the bundle(s). Easy bizy.

# Performance

This project is currently at *very* early stages of development, which in my case means I haven't bothered making it do what it's
supposed to do fast. It's quite possible however that your app will still perform a lot better with it as is, depending on how 
lazy you were when writing your layouts/templates. After the first release I'll be addressing performance almost exclusively.

# Compared to...

rack-bundle is, as of now, a lot simpler (as in less features) than solutions such as [Jammit](http://documentcloud.github.com/jammit/).
But it is plug-and-play: you load up the middleware with a few configuration parameters and you're set. No need to modify templates, no
helpers, nothing.

# Heroku

Heroku support is in the works. As Heroku doesn't won't allow an application to write to the filesystem, rack-bundle won't work.
That will be addressed soon.

# License

It's as free as sneezing. Just give me credit if you make some extraordinary out of this.
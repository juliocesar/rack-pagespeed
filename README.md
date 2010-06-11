# rack-bundle

A Rack middleware for grouping Javascripts into one single file. It also works for stylesheets, grouping them by media type.

# Usage

Rack:

    use Rack::Bundle, :public_dir => "path to your application's public directory"
    run app

Sinatra it's almost the same as above, except you don't need to explicitly call run as Sinatra will handle that:

    use Rack::Bundle, :public_dir => Sinatra::Application.public
    
As for Rails, google around how to add Rack middlewares to the stack. I'm too lazy right now to look it up. But as a
general pointer, I know it's in _ROOT/config/environment.rb_.

# A few assumptions

There's a few assumptions that this middleware makes in order to work. Note that *all* of those will change soon:

* That your app can write to a directory that's visible to the internet (a.k.a.: the application's public dir). I'm
aware that from a security perspective (and for the sake of this working on Heroku), this is a *bad* idea. Consider this an interim
measure so I can get something out quickly.
* That external Javascripts (read: not hosted on the same web server as the app itself) come *first* in the DOM. This may or
may not be an issue for you, but I've experienced a few. I'll add automatic reordering soon.
* That you're linking Javascripts inside the <head> tag. It won't break your app if you don't. But scripts that sit outside
will be ignored.

# How does it work

It parses the response body using [Nokogiri](http://nokogiri.org/), finds every reference to external scripts/stylesheets, locates
them in the file system, bundles them, saves the bundle in the application's public directory, and replaces the references in the
response for one single reference to the bundle(s).

# Performance

This project is currently at *very* early stages of development, which in my case means I haven't bothered making it do what it's
supposed to do fast. It's quite possible however that your app will still perform a lot better with it as is, depending on how 
lazy you were when writing your layouts/templates. After the first release I'll be addressing performance almost exclusively.

# Compared to...

rack-bundle is, as of now, a lot simpler (as in less features) than solutions such as [Jammit](http://documentcloud.github.com/jammit/).
But it is plug-and-play: you load up the middleware with a few configuration parameters and you're set. No need to modify templates, no
helpers, nothing. Oh also, it's framework agnostic, and that's priceless.

# Heroku

Heroku support is in the works. As Heroku doesn't won't allow an application to write to the filesystem, rack-bundle won't work.
That will be addressed soon.

# License

It's as free as sneezing. Just give me credit (http://twitter.com/julio_ody) if you make some extraordinary out of this.
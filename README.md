# rack-bundle

A Rack middleware for grouping Javascripts and stylesheets into one single file (styles are grouped by media type). 

# Installation

    $ sudo gem install rack-bundle

# Usage

Rack:

    use Rack::Bundle, :public_dir => "path/to/app/public/dir"
    run app

Sinatra it's almost the same as above, except you don't need to explicitly call run as Sinatra will handle that:

    use Rack::Bundle, :public_dir => Sinatra::Application.public
    
As for Rails, google around how to add Rack middlewares to the stack. I'm too lazy right now to look it up. But as a general pointer, I know it's in _ROOT/config/environment.rb_.

By default, this middleware will use the file system for storing bundles. For Heroku and a few other setups where the application doesn't have permission to write to certain directories, you can store and serve bundles directly from a database. Like so:

    use Rack::Bundle, :public_dir => 'path/to/public' do |rack_bundle|
      rack_bundle.storage = Rack::Bundle::DatabaseStore.new
    end

_DatabaseStore_ assumes an environment variable called *DATABASE_URL* exists, which is an URL that the adapter can use to connect to a database ([See examples](http://sequel.rubyforge.org/rdoc/files/doc/opening_databases_rdoc.html)). You can alternatively supply that as parameter. For instance:

    use Rack::Bundle, :public_dir => 'path/to/public' do |rack_bundle|
      rack_bundle.storage = Rack::Bundle::DatabaseStore.new "sqlite://foo.sqlite3"
    end
    

# A few assumptions

There's a few assumptions that this middleware makes in order to work. Note that *all* of those will change soon:

* That external Javascripts (read: not hosted on the same web server as the app itself) come *first* in the DOM. This may or may not be an issue for you, but I've experienced a few. I'll add automatic reordering soon.
* That you're linking Javascripts inside the <head> tag. It won't break your app if you don't. But scripts that sit outside will be ignored.

# How does it work

It parses the response body using [Nokogiri](http://nokogiri.org/), finds every reference to external scripts/stylesheets, locates them in the file system, bundles them, saves the bundle in the application's public directory, and replaces the references in the response for one single reference to the bundle(s).

# Performance

This project is currently at *very* early stages of development, which in my case means I haven't bothered making it do what it's supposed to do fast. It's quite possible however that your app will still perform a lot better with it as is, depending on how lazy you were when writing your layouts/templates. After the first release I'll be addressing performance almost exclusively.

# Compared to...

rack-bundle is, as of now, a lot simpler (as in less features) than solutions such as [Jammit](http://documentcloud.github.com/jammit/). But it is plug-and-play: you load up the middleware with a few configuration parameters and you're set. No need to modify templates, no helpers, nothing. Oh also, it's framework agnostic, and that's priceless.

# License

It's as free as sneezing. Just give me credit (http://twitter.com/julio_ody) if you make some extraordinary out of this.
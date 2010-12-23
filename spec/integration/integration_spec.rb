require File.dirname(__FILE__) + '/../spec_helper'
require 'steak'
require 'capybara'
require 'capybara/dsl'

RSpec.configure do |config|
  config.include Capybara
  config.before :all do
    `mkdir #{Dir.tmpdir}/pagespeed`
  end
  config.after :all do
    `rm -rf #{Dir.tmpdir}/pagespeed`
  end
  Capybara.app = Rack::Builder.new do
    zecoolwebsite = File.join(Fixtures.path, 'zecoolwebsite')
    use Rack::Lint
    use Rack::Static, :root => zecoolwebsite, :urls => %w(/img /css /js)
    use Rack::PageSpeed, :public => zecoolwebsite do
      store :disk => Dir.tmpdir + '/pagespeed'
      inline_javascripts
      inline_css
      combine_javascripts
      combine_css
    end
    run lambda { |env| [200, { 'Content-Type' => 'text/html' }, [File.read(File.join(zecoolwebsite, 'index.html')) ] ] }
  end
end

feature "playing out in the real world" do
  scenario "inlines sayhi.js" do
    visit '/'
    page.body.should include(fixture('zecoolwebsite/js/sayhi.js'))
  end
  
  scenario "bundles jquery and awesomebydesign.js together" do
    visit '/'
    page.should have_css('script[src*="rack-pagespeed"]')
    page.should_not have_css('script[src*="jquery"]')
    page.should_not have_css('script[src*="awesomebydesign"]')    
    
    visit page.find('script[src*="rack-pagespeed"]')['src']
    page.body.should == [fixture('zecoolwebsite/js/jquery-1.4.2.min.js'), fixture('zecoolwebsite/js/awesomebydesign.js')].join(';')
  end
  
  scenario "bundles reset.css and awesomebydesign.css together" do
    visit '/'
    page.should have_css('link[rel="stylesheet"][href*="rack-pagespeed"]')
    page.should_not have_css('link[rel="stylesheet"][href*="reset.css"]')
    page.should_not have_css('link[rel="stylesheet"][href*="awesomebydesign.css"]')    
    
    visit page.find('link[rel="stylesheet"][href*="rack-pagespeed"]')['href']
    page.body.should == [fixture('zecoolwebsite/css/reset.css'), fixture('zecoolwebsite/css/awesomebydesign.css')].join("\n")
  end
end
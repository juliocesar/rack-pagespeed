use Rack::Static, :root => File.dirname(__FILE__), :urls => %w(/img /css /js)
run lambda { |env| [200, { 'Content-Type' => 'text/html' }, [File.read('index.html')]] }
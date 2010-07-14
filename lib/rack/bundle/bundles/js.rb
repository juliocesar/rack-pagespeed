require File.dirname(__FILE__) + '/base'

class Rack::Bundle::JSBundle < Rack::Bundle::Base  
  @extension, @joiner, @mime_type = "js", ";", "text/javascript"
  
  def contents
    @contents ||= @files.map { |file| file.contents }.join(joiner)
  end
  
  # Leaving this comment here for the sake of documenting my intention.
  # For some reason, opening the pipe below makes Rack hang indefinitely,
  # even though specs pass.
  # 
  # def compress javascript
  #   compressed = ""
  #   open(%Q{| #{Rack::Bundle.vendor_path}/jsmin.rb}, 'w+') do |process|
  #     process.write javascript
  #     process.close_write
  #     compressed = process.read
  #   end
  #   puts compressed
  #   compressed
  # end
end
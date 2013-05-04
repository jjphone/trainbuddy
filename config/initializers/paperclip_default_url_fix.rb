module Paperclip
  module Interpolations
    def self.interpolate pattern, *args
      pattern = args.first.instance.send(pattern) if pattern.kind_of? Symbol
      all.reverse.inject( pattern.dup ) do |result, tag|
        result.gsub(/:#{tag}/) do |match|
          send( tag, *args )
        end
      end
    end

    def web_root(attachment, style_name)
      '/trainbuddy'
    end

    
  end
end
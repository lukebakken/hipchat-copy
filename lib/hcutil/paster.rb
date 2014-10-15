require 'uri'
require 'hcutil/errors'
require 'hcutil/op_base'

module HCUtil

  class Paster < OpBase
    def initialize(thing, options = {})
      super(options)
      @thing = thing
      @room = options[:room]
      @ticket = options[:ticket]
      @summary = options[:summary]
    end

    def paste
      if @thing == '-'
        thing_contents = $stdin.read
      elsif File.exists?(@thing)
        thing_contents = File.read(@thing)
      else
        thing_contents = @thing
      end

      if @ticket
        ticket_text = "ticket ##{@ticket} - "
      end
      unless ticket_text.nil_or_empty? and @summary.nil_or_empty?
        paste_header = "#{ticket_text}#{@summary}\n"
      end
      message = <<"EOT"
#{paste_header}
#{thing_contents}
EOT
      post_data = {
        :message_format => 'text',
        :color => 'purple',
        :message => message
      }

      header_args = {
        :content_type => :json,
        :accept => :json,
        :authorization => "Bearer #{@auth.auth_token}"
      }

      room_esc = URI.escape(@room.to_s)
      uri = "https://api.hipchat.com/v2/room/#{room_esc}/notification"
      post_request(uri, post_data.to_json, header_args)
    end
  end
end


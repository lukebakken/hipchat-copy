require 'uri'
require 'hcutil/errors'
require 'hcutil/op_base'

module HCUtil

  class Paster < OpBase
    def initialize(file, options = {})
      super(options)
      if file == '-' or File.exists?(file)
        @file = file
      else
        raise(Errors::PasterError, "Response file '#{file}' does not exist")
      end
      @room = options[:room]
      @ticket = options[:ticket]
      @summary = options[:summary]
    end

    def paste
      if @file == '-'
        file_contents = $stdin.read
      else
        file_contents = File.read(@file)
      end

      if @ticket
        ticket_text = "ticket ##{@ticket} - "
      end
      unless ticket_text.nil_or_empty? and @summary.nil_or_empty?
        paste_header = "#{ticket_text}#{@summary}\n"
      end
      message = <<"EOT"
#{paste_header}
#{file_contents}
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
      RestClient.post(uri, post_data.to_json, header_args) do |response, request, result|
        unless result.is_a? Net::HTTPSuccess
          raise(Errors::RESTError.new(result, uri, response))
        end
      end
    end
  end
end


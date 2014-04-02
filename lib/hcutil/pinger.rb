require 'hcutil/op_base'

module HCUtil

  class PingerError < StandardError
    def initialize(msg = 'PingerError')
      super
    end
  end

  class Pinger < OpBase
    def initialize(ticket_num = nil, response_file = nil, summary = nil, options = {})
      super(options)
      if ticket_num =~ /^[0-9]{4,}$/
        @ticket_num = ticket_num
      else
        raise(PingerError, 'Ticket number must be 4 or more digits')
      end
      if File.exists?(response_file)
        @response_file = response_file
      else
        raise(PingerError, "Response file '#{response_file}' does not exist")
      end
      @summary = summary
    end

    def ping
      message = <<"EOT"
ticket ##{@ticket_num} - #{@summary}
#{File.read(@response_file)}
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

      RestClient.post('https://api.hipchat.com/v2/room/61640/notification',
                      post_data.to_json, header_args) do |response, request, result|
        unless result.is_a? Net::HTTPSuccess
          raise(PingerError, "REST error: #{result}|#{response}")
        end
      end
    end
  end
end


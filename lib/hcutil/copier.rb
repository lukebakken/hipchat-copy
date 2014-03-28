require 'json'
require 'rest_client'
require 'time'
require 'uri'

module HCUtil

  class CopierError < StandardError
  end

  class Copier
    def initialize(options = {})

      debug = options[:debug]
      verbose = options[:verbose] || options[:debug]
      room_name = options[:room] || ARGV[0] || 'Client Services'
      num_items = options[:num_items] || ARGV[1] || 25

      RestClient.log = 'stdout' if debug

      @auth = Auth.new(verbose)

    end

    def copy
      room_name_esc = URI.escape(room_name)
      room_id = 0
      RestClient.get("https://api.hipchat.com/v2/room/#{room_name_esc}", param_arg) do |response, request, result|
        json = JSON.parse(response.body)
        room_id = json['id']
        puts "Room '#{room_name}' has ID #{room_id}" if verbose
      end

      chat_date = options[:date]
      puts "Getting history for #{chat_date.to_s}" if verbose

      param_arg = {
        :accept => :json,
        :params => {
          :auth_token => auth_token,
          :date => chat_date,
          'max-results' => num_items
        }
      }

      json = nil
      RestClient.get("https://api.hipchat.com/v2/room/#{room_id}/history", param_arg) do |response, request, result|
        json = JSON.parse(response.body)
      end

      if debug
        chat_json_file = "messages-#{room_id}-#{chat_date.strftime('%Y-%m-%d')}.json"
        File.open(chat_json_file, 'w') { |f| f.write(json.inspect) }
        puts "Chat JSON saved to #{chat_json_file}"
      end

      items = json['items']
      items.each do |item|
        date = Time.parse(item['date']).strftime('%Y-%m-%d %H:%M:%S')
        from = item['from']
        if from.is_a?(Hash)
          name = from['name']
        else
          name = from
        end
        message = item['message']
        puts "#{date} #{name}: #{message}"
      end
    end

    private

    def param_arg
      param_arg = {
        :accept => :json,
        :params => {
          :auth_token => @auth.auth_token
        }
      }
    end

  end
end

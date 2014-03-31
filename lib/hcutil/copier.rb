require 'json'
require 'rest_client'
require 'time'

require 'hcutil/auth'

module HCUtil

  class CopierError < StandardError
    def initialize(msg = 'CopierError')
      super
    end
  end

  class Copier
    def initialize(room_name = 'Client Services', options = {})
      @room_name = room_name
      @options = options

      @debug = @options[:debug]
      @verbose = @options[:verbose] || @options[:debug]
      @num_items = @options[:num_items] ||25

      RestClient.log = 'stdout' if @debug
      @auth = Auth.new(@options)
    end

    def copy
      room_id = 0

      param_arg = {
        :accept => :json,
        :params => {
          :auth_token => @auth.auth_token
        }
      }
      RestClient.get('https://api.hipchat.com/v2/room', param_arg) do |response, request, result|
        if result.is_a? Net::HTTPSuccess
          json = JSON.parse(response.body)
          items = json['items']
          items.each do |item|
            if item['name'] == @room_name
              room_id = item['id']
              $stderr.puts("Room '#{@room_name}' has ID #{room_id}") if @verbose
              break
            end
          end
        else
          raise(CopierError, "REST error: #{result}|#{response}")
        end
      end

      chat_date = @options[:date]
      $stderr.puts("Getting history for #{chat_date.to_s}") if @verbose

      param_arg = {
        :accept => :json,
        :params => {
          :auth_token => @auth.auth_token,
          :date => chat_date,
          'max-results' => @num_items
        }
      }

      json = nil
      RestClient.get("https://api.hipchat.com/v2/room/#{room_id}/history", param_arg) do |response, request, result|
        if result.is_a? Net::HTTPSuccess
          json = JSON.parse(response.body)
        else
          raise(CopierError, "REST error: #{result}|#{response}")
        end
      end

      if @debug
        chat_json_file = "messages-#{room_id}-#{chat_date.strftime('%Y-%m-%d')}.json"
        File.open(chat_json_file, 'w') { |f| f.write(json.inspect) }
        $stderr.puts "Chat JSON saved to #{chat_json_file}"
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
  end
end


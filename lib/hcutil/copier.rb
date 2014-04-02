require 'hcutil/errors'
require 'hcutil/op_base'

module HCUtil

  class Copier < OpBase
    def initialize(room_name = 'Client Services', options = {})
      super(options)
      @room_name = room_name
      @num_items = @options[:num_items] ||25
    end

    def copy
      room_id = 0

      param_arg = {
        :accept => :json,
        :params => {
          :auth_token => @auth.auth_token
        }
      }
      uri = 'https://api.hipchat.com/v2/room'
      RestClient.get(uri, param_arg) do |response, request, result|
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
          raise(Errors::RESTError.new(result, uri, response))
        end
      end

      if room_id == 0
        raise(Errors::CopierError, "Room with name '#{@room_name}' could not be found")
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

      uri = "https://api.hipchat.com/v2/room/#{room_id}/history"
      json = nil
      RestClient.get(uri, param_arg) do |response, request, result|
        if result.is_a? Net::HTTPSuccess
          json = JSON.parse(response.body)
        else
          raise(Errors::RESTError.new(result, uri, response))
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


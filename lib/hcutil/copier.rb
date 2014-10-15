require 'hcutil/errors'
require 'hcutil/op_base'
require 'uri'
require 'cgi'

module HCUtil

  class Copier < OpBase
    def initialize(room_name = 'Client Services', options = {})
      super(options)
      @room_name = room_name
      @num_items = @options[:num_items] ||25
    end

    def get_room_id(start_index=0)

      uri = 'https://api.hipchat.com/v2/room'

      # First, try to get the room directly by name
      if start_index == 0
        param_arg = {
          :accept => :json,
          :params => {
            'auth_token' => @auth.auth_token
          }
        }
        uri_direct = uri + URI.escape("/#{@room_name}")
        get_request(uri_direct, param_arg) do |response, request, result|
          if result.is_a? Net::HTTPSuccess
            json = JSON.parse(response.body)
            if json['id']
              room_id = json['id']
              $stderr.puts("Room '#{@room_name}' has ID #{room_id}") if @verbose
              return room_id
            end
          end
        end
      end

      param_arg = {
        :accept => :json,
        :params => {
          'auth_token' => @auth.auth_token,
          'start-index' => start_index,
          'max-results' => 100
        }
      }

      room_id = 0

      get_request(uri, param_arg) do |response, request, result|
        if result.is_a? Net::HTTPSuccess
          json = JSON.parse(response.body)
          if json['items']
            items = json['items']
            items.each do |item|
              if item['name'] == @room_name
                room_id = item['id']
                $stderr.puts("Room '#{@room_name}' has ID #{room_id}") if @verbose
                break
              end
            end
            links = json['links']
            if room_id == 0 and not links.nil?
              next_uri = links['next']
              unless next_uri.nil_or_empty?
                query = URI.parse(next_uri).query
                query_params = CGI.parse(query)
                start_index = query_params['start-index'].first
                $stderr.puts("finding '#{@room_name}' with start_index #{start_index}") if @verbose
                return get_room_id(start_index)
              end
            end
          else
            raise(Errors::CopierError, "Room with name '#{@room_name}' could not be found - could not parse JSON")
          end
        else
          raise(Errors::RESTError.new(result, uri, response))
        end
      end
      return room_id
    end

    def copy
      room_id = get_room_id
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
      get_request(uri, param_arg) do |response, request, result|
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


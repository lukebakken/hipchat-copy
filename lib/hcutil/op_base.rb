require 'json'
require 'rest_client'
require 'time'
require 'hcutil/auth'

module HCUtil
  class OpBase
    def initialize(options = {})
      @options = options
      @debug = @options[:debug]
      @verbose = @options[:verbose] || @options[:debug]
      RestClient.log = 'stdout' if @debug
      @auth = Auth.new(@options)
    end

    def post_request(url, payload, headers)
      RestClient::Request.execute(:url => url, :method => :post,
                                  :payload => payload, :headers => headers,
                                  :ssl_version => :TLSv1_2) do |response, request, result|
        if block_given?
          yield(response, request, result)
        else
          unless result.is_a? Net::HTTPSuccess
            raise(Errors::RESTError.new(result, url, response))
          end
        end
      end
    end

    def get_request(url, headers)
      RestClient::Request.execute(:url => url, :method => :get,
                                  :headers => headers,
                                  :ssl_version => :TLSv1_2) do |response, request, result|
        if block_given?
          yield(response, request, result)
        else
          unless result.is_a? Net::HTTPSuccess
            raise(Errors::RESTError.new(result, url, response))
          end
        end
      end
    end
  end
end


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
  end
end


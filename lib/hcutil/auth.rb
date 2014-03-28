module HCUtil
  class AuthError < StandardError
    def initialize(data)
      @data = data
    end
  end

  class Auth

    attr_reader :auth_token

    def initialize(options = {})
      if ENV['HOME'].nil? or
         ENV['HOME'] == '' or
         (not Dir.exist?(ENV['HOME']))
        raise AuthError.new('[error]: HOME env var not set or dir does not exist')
      end

      auth_file = File.join(ENV['HOME'], '.hcapi')
      if File.exists?(auth_file)
        @auth_token = File.read(auth_file).gsub("\n", ' ').squeeze(' ')
        $stderr.puts("Auth token: #{auth_token}") if options[:verbose]
      else
        raise AuthError.new('[error]: missing auth token file ~/.hcapi')
      end
    end
  end
end


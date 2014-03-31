module HCUtil
  class AuthError < StandardError
    def initialize(msg = 'AuthError')
      super
    end
  end

  class Auth

    attr_reader :auth_token

    def initialize(options = {})
      home_env = ENV['HOME']
      if home_env.nil_or_empty? or not Dir.exist?(ENV['HOME'])
        raise(AuthError, 'HOME env var not set or dir does not exist')
      end

      auth_file = File.join(ENV['HOME'], '.hcapi')
      if File.exists?(auth_file)
        @auth_token = File.read(auth_file).gsub("\n", ' ').squeeze(' ')
        $stderr.puts("Auth token: #{auth_token}") if options[:verbose]
      else
        raise(AuthError, 'missing auth token file ~/.hcapi')
      end
    end
  end
end


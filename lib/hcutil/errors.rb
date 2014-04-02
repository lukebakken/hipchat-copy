module HCUtil
  module Errors

    class HCUtilError < StandardError; end

    class AuthError < HCUtilError
      def initialize(msg = 'AuthError')
        super
      end
    end

    class RESTError < HCUtilError
      def initialize(result, uri, response)
        super("#{result.code} #{result.msg}\n#{uri}\n#{response}")
      end
    end

    class CopierError < HCUtilError
      def initialize(msg = 'CopierError')
        super
      end
    end

    class PasterError < HCUtilError
      def initialize(msg = 'PasterError')
        super
      end
    end

  end
end


module ActionKit
  module Cache
    module Worthless
      module_function

      def fetch(_key, _options = {}, &block)
        block.call
      end
    end
  end
end

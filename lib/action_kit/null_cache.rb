module ActionKit
  module NullCache
    module_function

    def fetch(_key, _options = {}, &block)
      block.call
    end
  end
end

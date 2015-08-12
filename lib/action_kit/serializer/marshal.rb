module ActionKit
  module Serializer
    module Marshal
      module_function

      def dump(obj)
        ::Marshal.dump(obj)
      end

      def load(data)
        ::Marshal.load(data)
      end
    end
  end
end

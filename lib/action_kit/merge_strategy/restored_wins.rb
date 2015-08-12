module ActionKit
  module MergeStrategy
    module RestoredWins
      module_function

      # Private: Merge the restored context into the existing context.
      #
      # Note: The restored context _will_ overwrite the values on the existing
      #       context.
      #
      # context  - The current interactor context.
      # restored - The un-frozen context from cache.
      #
      # Returns the existing context with the restored values.
      def merge(context, restored)
        restored_hash = restored.marshal_dump
        restored_hash.each do |key, value|
          context.__send__(:"#{key}=", value)
        end

        context
      end
    end
  end
end

module ActionKit
  module MergeStrategy
    module Paranoid
      module_function

      # Private: Merge the restored context into the existing context. Only
      #          new keys are added to the old context.
      #
      # context  - The current interactor context.
      # restored - The un-frozen context from cache.
      #
      # Returns the existing context with the restored values.
      def merge(context, restored)
        restored_hash = restored.marshal_dump

        restored_hash.each do |key, value|
          unless context.respond_to?(key)
            context.__send__(:"#{key}=", value)
          end
        end

        context
      end
    end
  end
end

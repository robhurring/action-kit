module ActionKit
  module MergeStrategy
    module Clobber
      module_function

      # Private: Merge the restored context into the existing context. This will
      #          overwrite any attributes on the existing context!
      #
      # Note: Due to how `Interactor::Organizer` works this may end up clobbering
      #       data on the existing context by overwriting it with a cached version.
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

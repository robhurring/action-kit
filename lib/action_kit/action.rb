require 'set'

module ActionKit
  # Public: A more strict interactor that can verify the context is giving and
  #         receiving the proper context attributes.
  module Action
    extend ActiveSupport::Concern

    # Public: Raised when attributes that are expected are not given, or
    #         attributes that were promised were not provided.
    MissingAttributeError = Class.new(RuntimeError)

    # Public: Can be used as a noop to provide clarity and/or context
    #
    # Example:
    #
    #    expects :nothing  # => noop
    #    promises :nothing # => noop
    #
    NOTHING_KEY = :nothing

    included do |_base|
      include Interactor

      # Private: List of attributes we expect the context to provide
      class_attribute :_expects
      self._expects = Set.new

      # Private: List of attributes we expect to provide the context
      class_attribute :_promises
      self._promises = Set.new

      # Private: verify all expected attributes before running
      before :_verify_expects!

      # Private: verify all provided attributes after a successful run
      after :_verify_promises!
    end

    module ClassMethods
      # Public: A list of attribute you expect the context to provide to you. If
      #         _any_ are missing from context it will raise an error.
      #
      # Returns nothing.
      def expects(*keys)
        keys.delete(NOTHING_KEY)
        self._expects |= keys
      end

      # Public: A list of attributes you expect to provide the context
      #         _any_ are missing from context it will raise an error.
      #
      #         These provided attributes are only checked when the
      #         result is successful
      #
      # Returns nothing.
      def promises(*keys)
        keys.delete(NOTHING_KEY)
        self._promises |= keys
      end
    end

    # Private: Verify that our context has all the expected attributes, or raise
    #          an error.
    #
    # Returns nothing on success.
    # Raises MissingAttributeError on error.
    def _verify_expects!
      message = 'Expected %{missing} but didnt get it!'
      _verify(self.class._expects, message)
    end

    # Private: Verify that our context provides has all the expected attributes,
    #          or raise an error.
    #
    # Returns nothing on success.
    # Raises MissingAttributeError on error.
    def _verify_promises!
      message = 'Promised to provide %{missing} but didnt!'
      _verify(self.class._promises, message)
    end

    # Private: Verify that our expected keys are in the context.
    #
    # expected  - A Set of expected attributes in the context.
    # message   - A message template for the error to be raised.
    #
    # Returns nothing on success.
    # Raises MissingAttributeError on error.
    def _verify(expected, message)
      unless expected.subset?(_context_attributes)
        diff = expected.difference(_context_attributes)
        raise MissingAttributeError, message % {missing: diff.to_a.join(', ')}
      end
    end

    # Private: A list of attributes in the context.
    #
    # Returns a Set of the context's attributes.
    def _context_attributes
      (context.marshal_dump.keys || []).to_set
    end
  end
end

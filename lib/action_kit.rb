require "action_kit/version"

require 'active_support/concern'
require 'active_support/deprecation'
require 'active_support/core_ext/module'
require 'active_support/core_ext/class'

module ActionKit
  autoload :Action, 'action_kit/action'
  autoload :ActionCache, 'action_kit/action_cache'

  module Cache
    autoload :Worthless, 'action_kit/cache/worthless'
  end

  module Serializer
    autoload :Marshal, 'action_kit/serializer/marshal'
  end
end

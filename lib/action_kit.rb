require "action_kit/version"

require 'active_support/concern'
require 'active_support/deprecation'
require 'active_support/core_ext/module'
require 'active_support/core_ext/class'

module ActionKit
  autoload :Action, 'action_kit/action'
  autoload :ActionCache, 'action_kit/action_cache'
  autoload :NullCache, 'action_kit/null_cache'
end

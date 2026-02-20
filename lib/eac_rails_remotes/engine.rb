# frozen_string_literal: true

require 'eac_active_scaffold'
require 'eac_rails_utils'
require 'eac_ruby_utils'

module EacRailsRemotes
  class Engine < ::Rails::Engine
    include ::EacRailsUtils::EngineHelper

    isolate_namespace ::EacRailsRemotes
  end
end

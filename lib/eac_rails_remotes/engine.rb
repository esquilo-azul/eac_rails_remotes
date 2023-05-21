# frozen_string_literal: true

require_dependency 'eac_active_scaffold/engine'
require_dependency 'eac_rails_utils/engine_helper'

module EacRailsRemotes
  class Engine < ::Rails::Engine
    include ::EacRailsUtils::EngineHelper
    isolate_namespace ::EacRailsRemotes
  end
end

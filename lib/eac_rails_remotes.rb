# frozen_string_literal: true

require 'eac_ruby_utils'
EacRubyUtils::RootModuleSetup.perform __FILE__

module EacRailsRemotes
end

require 'eac_active_scaffold'
require 'eac_rails_utils'

require 'eac_rails_remotes/engine'

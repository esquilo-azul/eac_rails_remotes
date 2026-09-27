# frozen_string_literal: true

RSpec.describe EacRailsRemotes::InstancesController, type: :feature do
  include_context 'active_scaffold_controller',
                  index_path: '/eac_rails_remotes/instances'
end

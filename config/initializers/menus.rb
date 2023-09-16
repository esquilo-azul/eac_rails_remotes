# frozen_string_literal: true

require 'eac_rails_utils/patches/application'

::Rails.application.root_menu.group(:admin).group(:eac_rails_remotes, :eac_rails_remotes)
       .within do |g|
  g.action(:instances).label(-> { ::EacRailsRemotes::Instance.plural_name })
end

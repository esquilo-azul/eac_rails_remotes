# frozen_string_literal: true

::Rails.application.routes.draw do
  mount ::EacRailsRemotes::Engine => '/eac_rails_remotes'
end

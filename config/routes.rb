# frozen_string_literal: true

EacRailsRemotes::Engine.routes.draw do
  resources(:instances, concerns: active_scaffold)
end

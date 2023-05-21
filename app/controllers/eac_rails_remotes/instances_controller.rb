# frozen_string_literal: true

module EacRailsRemotes
  class InstancesController < ApplicationController
    before_action :localize_options

    active_scaffold :'eac_rails_remotes/instance' do |conf|
      conf.actions.exclude :create, :update
      conf.columns[:export_status].form_ui = :select
      conf.columns[:entity].form_ui = :select
      conf.actions.swap :search, :field_search
      conf.field_search.columns = :entity, :export_status
    end

    private

    def localize_options
      active_scaffold_config.columns[:export_status].options = {
        options: ::EacRailsRemotes::Instance.lists.export_status.options
      }
      active_scaffold_config.columns[:entity].options = {
        options: ::EacRailsRemotes::Instance.select(:entity).order(entity: :asc).distinct
                                            .pluck(:entity)
      }
    end
  end
end

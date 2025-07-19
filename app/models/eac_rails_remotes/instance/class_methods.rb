# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRailsRemotes
  class Instance < ::ActiveRecord::Base
    module ClassMethods
      common_concern
      class_methods do
        # @param record [Hash]
        # @return [EacRailsRemotes::Instance]
        def import(record)
          ri = where(source: record.fetch(:source), entity: sanitize_entity(record.fetch(:entity)),
                     code: record.fetch(:code)).first_or_initialize
          ri.parsed_data = record.fetch(:data)
          if ri.data_changed?
            ri.export_status = EXPORT_STATUS_NEW_DATA
            ri.save!
          end
          ri
        end

        # @oaram entity [Object]
        # @return [String]
        def sanitize_entity(entity)
          entity.is_a?(::Module) ? entity.name : entity.to_s
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRailsRemotes
  class Instance < ::ActiveRecord::Base
    self.table_name = 'eac_rails_remotes_instances'
    enable_listable
    lists.add_integer :export_status, :new_data, :ok, :error

    validates :source, presence: true
    validates :entity, presence: true
    validates :code, presence: true, uniqueness: { scope: %i[source entity] } # rubocop:disable Rails/UniqueValidationWithoutIndex
    validates :data, presence: true
    validates :export_status, presence: true, inclusion: { in: lists.export_status.values }

    belongs_to :target, polymorphic: true, optional: true

    scope :pending, lambda {
      where.not(export_status: EXPORT_STATUS_OK)
    }

    # @return [Object]
    def parsed_data
      data.if_present(nil) { |v| ::EacRubyUtils::Yaml.load(v) }
    end

    # @param value [Object]
    def parsed_data=(value)
      self.data = value.if_present(nil) { |v| ::EacRubyUtils::Yaml.dump(v) }
    end

    def to_s
      "#{source}|#{entity}|#{code}"
    end

    # @return [Object]
    def assert_target
      return target if target.present?

      export if export_status != EXPORT_STATUS_ERROR
      return target if target.present?

      raise "Export failed (ID: #{id}, export message: \"#{export_message}\""
    end

    # @return [Class<ActiveRecord::Base>]
    def entity_class
      entity.constantize
    end

    require_sub __FILE__, require_mode: :kernel, include_modules: true
  end
end

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

    scope :pendent, lambda {
      where.not(export_status: EXPORT_STATUS_OK)
    }

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

    def export
      Rails.logger.info("Exporting #{self}")
      t = target || entity_class.new
      t.attributes = target_attributes
      if t.save
        update!(export_status: EXPORT_STATUS_OK, export_message: '', target: t)
      else
        update!(export_status: EXPORT_STATUS_ERROR,
                export_message: target_export_message(t))
      end
    end

    # @return [Class<ActiveRecord::Base>]
    def entity_class
      entity.constantize
    end

    private

    def target_attributes
      EacRubyUtils::Yaml.load(data).to_h { |k, v| target_attribute(k, v) }
    end

    def target_attribute(attr, value)
      a = entity_association_class(attr)
      return [attr, value] unless a

      ri = self.class.find_by(source: source, entity: a.klass.name, code: value)
      [a.name, ri&.target]
    end

    # @return [ActiveRecord::Reflection::BelongsToReflection, nil]
    def entity_association_class(attribute)
      entity_class.reflect_on_all_associations(:belongs_to)
        .find { |x| x.foreign_key.to_sym == attribute.to_sym }
    end

    def target_export_message(target)
      "ATTRIBUTES: #{target.attributes}\nERRORS: #{target.errors.messages}\n"
    end

    class << self
      # @param record [Hash]
      # @return [EacRailsRemotes::Instance]
      def import(record)
        ri = where(source: record.fetch(:source), entity: sanitize_entity(record.fetch(:entity)),
                   code: record.fetch(:code)).first_or_initialize
        ri.data = record.fetch(:data).to_yaml
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

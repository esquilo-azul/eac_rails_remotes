# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRailsRemotes
  class Instance < ::ActiveRecord::Base
    class ExportTargetAttribute
      acts_as_instance_method
      enable_simple_cache
      common_constructor :instance, :attribute, :value

      # @return [Array]
      def result
        return nil unless valid?
        return [attribute, value] unless entity_association_class

        result_by_association
      end

      protected

      # @return [EacRailsRemotes::Instance]
      def association_record_uncached
        instance.class.find_by(
          source: instance.source, entity: entity_association_class.klass.name, code: value
        )
      end

      # @return [ActiveRecord::Reflection::BelongsToReflection, nil]
      def entity_association_class_uncached
        instance.entity_class.reflect_on_all_associations(:belongs_to)
          .find { |x| x.foreign_key.to_sym == attribute.to_sym }
      end

      # @return [Array]
      def result_by_association
        [entity_association_class.name, association_record&.assert_target]
      end

      # @return [Boolean]
      def valid?
        instance.entity_class.primary_key != attribute.to_s &&
          instance.entity_class.new.respond_to?("#{attribute}=")
      end
    end
  end
end

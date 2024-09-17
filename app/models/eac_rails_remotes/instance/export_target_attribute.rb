# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRailsRemotes
  class Instance < ::ActiveRecord::Base
    class ExportTargetAttribute
      acts_as_instance_method
      common_constructor :instance, :attribute, :value

      # @return [Array]
      def result
        a = entity_association_class
        return [attribute, value] unless a

        ri = instance.class.find_by(source: instance.source, entity: a.klass.name, code: value)
        [a.name, ri&.target]
      end

      protected

      # @return [ActiveRecord::Reflection::BelongsToReflection, nil]
      def entity_association_class
        instance.entity_class.reflect_on_all_associations(:belongs_to)
          .find { |x| x.foreign_key.to_sym == attribute.to_sym }
      end
    end
  end
end

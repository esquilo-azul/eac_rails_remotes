# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRailsRemotes
  class Instance < ::ActiveRecord::Base
    class Export < ::SimpleDelegator
      acts_as_instance_method

      def result
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

      protected

      # @return [Hash]
      def target_attributes
        parsed_data.to_h { |k, v| export_target_attribute(k, v) }
      end

      # @return [String]
      def target_export_message(target)
        "ATTRIBUTES: #{target.attributes}\nERRORS: #{target.errors.messages}\n"
      end
    end
  end
end

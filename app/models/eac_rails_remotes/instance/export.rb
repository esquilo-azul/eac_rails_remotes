# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRailsRemotes
  class Instance < ::ActiveRecord::Base
    class Export < ::SimpleDelegator
      acts_as_instance_method
      enable_simple_cache

      def result
        Rails.logger.info("Exporting #{self}")
        filled_target.save ? update_as_ok : update_as_error
      end

      protected

      # @return [ActiveRecord::Base]
      def filled_target_uncached
        t = target || entity_class.new
        t.attributes = target_attributes
        t
      end

      # @return [Hash]
      def target_attributes
        parsed_data.map { |k, v| export_target_attribute(k, v) }.compact_blank.to_h
      end

      # @return [String]
      def target_export_message(target)
        "ATTRIBUTES: #{target.attributes}\nERRORS: #{target.errors.messages}\n"
      end

      # @return [void]
      def update_as_error
        update!(export_status: EXPORT_STATUS_ERROR,
                export_message: target_export_message(filled_target))
      end

      # @return [void]
      def update_as_ok
        update!(export_status: EXPORT_STATUS_OK, export_message: '', target: filled_target)
      end
    end
  end
end

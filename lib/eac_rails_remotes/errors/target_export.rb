# frozen_string_literal: true

module EacRailsRemotes
  module Errors
    class TargetExport < ::RuntimeError
      attr_reader :record

      def initialize(record)
        super("Export failed (ID: #{record.id}, export message: \"#{record.export_message}\")")
        @record = record
      end
    end
  end
end

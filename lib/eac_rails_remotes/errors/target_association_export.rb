# frozen_string_literal: true

module EacRailsRemotes
  module Errors
    class TargetAssociationExport < ::EacRailsRemotes::Errors::TargetExport
      attr_reader :association_name, :owner_record

      def initialize(association_record, association_name, owner_record)
        super(association_record)
        @association_name = association_name
        @owner_record = owner_record
      end
    end
  end
end

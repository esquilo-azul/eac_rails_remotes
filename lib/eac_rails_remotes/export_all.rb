# frozen_string_literal: true

module EacRailsRemotes
  class ExportAll
    def perform
      ::EacRailsRemotes::Instance.pendent.each(&:export)
    end
  end
end

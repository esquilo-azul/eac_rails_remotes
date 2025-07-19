# frozen_string_literal: true

module EacRailsRemotes
  class ExportAll
    def perform
      ::EacRailsRemotes::Instance.pending.each(&:export)
    end
  end
end

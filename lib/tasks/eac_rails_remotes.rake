# frozen_string_literal: true

namespace :eac_rails_remotes do
  desc 'Import content from file'
  task :import_file, [:file] => :environment do |_t, args|
    EacRailsRemotes::ImportFile.new(args.file).perform
  end

  desc 'Export pending remote instances'
  task export_all: :environment do |_t, _args|
    EacRailsRemotes::Instance.pendent.each(&:export)
  end
end

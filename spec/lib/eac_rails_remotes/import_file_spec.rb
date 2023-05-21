# frozen_string_literal: true

::RSpec.describe(::EacRailsRemotes::ImportFile) do
  let(:file) { ::File.expand_path('import_file_spec_files/all.yaml', __dir__) }
  let(:import_error) { capture_error { described_class.new(file) } }
  let(:export_all_error) do
    import_error
    begin
      ::EacRailsRemotes::ExportAll.new.perform
      nil
    rescue ::StandardError => e
      e
    end
  end

  it { expect(import_error).to be_blank }
  it { expect(export_all_error).to be_blank }
end

# frozen_string_literal: true

RSpec.describe EacRailsRemotes::Instance, '#parsed_data' do
  let(:instance) do
    described_class.new(
      export_status: EacRailsRemotes::Instance::EXPORT_STATUS_NEW_DATA,
      source: 'ehbrs-web-utils_local',
      entity: 'Transaction',
      code: '5411'
    )
  end
  let(:parsed_data_value) { { a: 'AAA', b: 'BBB' } }
  let(:yaml_data_value) { EacRubyUtils::Yaml.dump(parsed_data_value) }

  it { expect(instance.data).to be_nil }
  it { expect(instance.parsed_data).to be_nil }

  context 'when set yaml data' do
    before do
      instance.data = yaml_data_value
    end

    it { expect(instance.parsed_data).to eq(parsed_data_value) }
    it { expect(instance.data).to eq(yaml_data_value) }

    context 'when is saved' do
      before do
        instance.save!
        instance.reload
      end

      it { expect(instance.parsed_data).to eq(parsed_data_value) }
      it { expect(instance.data).to eq(yaml_data_value) }
    end
  end
end

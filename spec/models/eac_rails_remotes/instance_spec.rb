# frozen_string_literal: true

::RSpec.describe ::EacRailsRemotes::Instance do
  let(:t_inst) do
    described_class.import(
      source: 'ehbrs-web-utils_local',
      entity: 'Transaction',
      code: '5411',
      data: {
        date: '2015-10-02',
        description: 'Ajudantes',
        label: '',
        from_id: '3',
        to_id: '106',
        amount: '120.0'
      }
    )
  end

  it { expect(t_inst).to be_present }
  it { expect(t_inst.source).to eq('ehbrs-web-utils_local') }
  it { expect(t_inst.entity).to eq('Transaction') }
  it { expect(t_inst.code).to eq('5411') }
  it { expect(t_inst.export_status).to eq(::EacRailsRemotes::Instance::EXPORT_STATUS_NEW_DATA) }
  it { expect(t_inst.export_message).to be_blank }
  it { expect(t_inst.target).to be_blank }

  context 'when transaction is exported without account' do
    before { t_inst.export }

    it { expect(t_inst.export_status).to eq(::EacRailsRemotes::Instance::EXPORT_STATUS_ERROR) }
    it { expect(t_inst.export_message).to be_present }
    it { expect(t_inst.target).to be_blank }

    context 'when account is imported' do
      let(:a_inst) do
        described_class.import(
          source: 'ehbrs-web-utils_local',
          entity: 'Account',
          code: '3',
          data: {
            name: 'Conta 1',
            parent_id: ''
          }
        )
      end

      it { expect(a_inst).to be_present }
      it { expect(a_inst.source).to eq('ehbrs-web-utils_local') }
      it { expect(a_inst.entity).to eq('Account') }
      it { expect(a_inst.code).to eq('3') }
      it { expect(a_inst.export_status).to eq(::EacRailsRemotes::Instance::EXPORT_STATUS_NEW_DATA) }
      it { expect(a_inst.export_message).to be_blank }
      it { expect(a_inst.target).to be_blank }

      context 'when account is exported' do
        before { a_inst.export }

        it { expect(a_inst.export_status).to eq(::EacRailsRemotes::Instance::EXPORT_STATUS_OK) }
        it { expect(a_inst.export_message).to be_blank }
        it { expect(a_inst.target).to be_a(::Account) }
        it { expect(a_inst.target.name).to eq('Conta 1') }
        it { expect(a_inst.target.parent).to be_blank }

        context 'when transaction is exported with account' do
          before { t_inst.export }

          it {
            expect(t_inst.export_status).to eq(::EacRailsRemotes::Instance::EXPORT_STATUS_OK),
                                            t_inst.export_message
          }

          it { expect(t_inst.export_message).to be_blank }
          it { expect(t_inst.target).to be_a(::Transaction) }

          it { expect(t_inst.target.description).to eq('Ajudantes') }
          it { expect(t_inst.target.label).to eq('') }
          it { expect(t_inst.target.date.strftime('%Y-%m-%d')).to eq('2015-10-02') }
          it { expect(t_inst.target.amount).to eq(120.0) }
          it { expect(t_inst.target.from).to eq(a_inst.target) }
        end
      end
    end
  end
end

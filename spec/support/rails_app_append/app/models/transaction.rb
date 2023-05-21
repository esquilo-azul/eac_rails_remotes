# frozen_string_literal: true

class Transaction < ::ActiveRecord::Base
  belongs_to :from, class_name: 'Account', optional: true
  belongs_to :to, class_name: 'Account', optional: true

  validates :amount, presence: true, numericality: { greater_than: 0.0 }
  validates :date, presence: true
  validate :from_not_equal_to
  validate :from_to_not_both_blank

  def from_not_equal_to
    return unless from.present? && to.present? && from == to

    %i[from to].each do |attr|
      errors.add(attr, 'Conta de origem não pode ser igual à conta de destino')
    end
  end

  def from_to_not_both_blank
    return unless from.blank? && to.blank?

    %i[from to].each do |attr|
      errors.add(attr, 'As contas de origem e destino não podem estar - ambas - em branco')
    end
  end
end

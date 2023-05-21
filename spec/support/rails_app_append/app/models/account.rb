# frozen_string_literal: true

class Account < ::ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :parent }

  belongs_to :parent, class_name: 'Account', optional: true
end

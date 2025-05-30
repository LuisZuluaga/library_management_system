class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_at, :due_at, presence: true

  before_validation :set_due_at, on: :create

  def set_due_at
    self.due_at ||= borrowed_at + 2.weeks if borrowed_at
  end
end

class Book < ApplicationRecord
  has_many :borrowings, dependent: :destroy

  validates :title, :author, :isbn, :total_copies, presence: true
  validates :isbn, uniqueness: true

  after_save :update_available_copies

  def update_available_copies
    update_column(:available_copies, total_copies - borrowings.where(returned_at: nil).count)
  end
end

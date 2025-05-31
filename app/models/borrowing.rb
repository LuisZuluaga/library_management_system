class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_at, :due_at, presence: true

  before_validation :set_due_at, on: :create
  after_save :refresh_book_available_copies
  after_destroy :refresh_book_available_copies

  def set_due_at
    self.due_at ||= borrowed_at + 2.weeks if borrowed_at
  end

  def refresh_book_available_copies
    book.update_column(:available_copies, book.total_copies - book.borrowings.where(returned_at: nil).count)
  end
end

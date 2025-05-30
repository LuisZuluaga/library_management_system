class DashboardController < ApplicationController
  def index
    if current_user.librarian?
      @books = Book.all
      @borrowed_books = Borrowing.where.not(returned_at: nil)
      @due_today = Borrowing.where(due_at: Date.today)
      @overdue_members = User.joins(:borrowings).where('borrowings.due_at < ? AND borrowings.returned_at IS NULL', Date.today).distinct
    elsif current_user.member?
      @my_books = current_user.borrowings.includes(:book)
    end
  end
end

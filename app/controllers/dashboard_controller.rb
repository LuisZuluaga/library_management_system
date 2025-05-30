class DashboardController < ApplicationController
  def index
    if current_user.librarian?
      @books = Book.all
      @borrowed_books = Borrowing.where.not(returned_at: nil)
      @due_today = Borrowing.where(due_at: Date.today.all_day, returned_at: nil)
      @overdue_members = User.joins(:borrowings).where('borrowings.due_at < ? AND borrowings.returned_at IS NULL', Date.today).distinct

      render 'librarian_dashboard'
    elsif current_user.member?
      @my_books = current_user.borrowings.includes(:book)

      render 'member_dashboard'
    end
  end
end

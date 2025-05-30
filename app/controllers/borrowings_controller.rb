class BorrowingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_borrowing, only: [:destroy]
  before_action :authorize_librarian!, only: [:return]

  def index
    @borrowings = current_user.librarian? ? Borrowing.all : current_user.borrowings
  end

  def create
    book = Book.find(params[:book_id])
    if current_user.member? && book.available_copies.positive? && !already_borrowed?(book)
      borrowing = current_user.borrowings.new(
        book: book,
        borrowed_at: Time.current,
        due_at: 2.weeks.from_now
      )

      Book.transaction do
        borrowing.save!
        book.decrement!(:available_copies)
      end

      redirect_to borrowings_path, notice: 'Book borrowed successfully.'
    else
      redirect_to books_path, alert: 'Cannot borrow this book.'
    end
  end

  def return
    if @borrowing.returned_at.nil?
      @borrowing.update(returned_at: Time.current)
      @borrowing.book.increment!(:available_copies)
    end

    redirect_to borrowings_path, notice: 'Book marked as returned.'
  end

  private

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  end

  def already_borrowed?(book)
    current_user.borrowings.where(book_id: book.id, returned_at: nil).exists?
  end

  def authorize_librarian!
    redirect_to root_path, alert: 'Access denied' unless current_user.librarian?
  end
end

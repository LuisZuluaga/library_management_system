class Api::V1::BorrowingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_borrowing, only: [:show, :return]
  before_action :authorize_librarian!, only: [:return]

  def index
    @borrowings = Borrowing.includes(:book, :user).all
    render json: @borrowings.as_json(include: [:book, :user]), status: :ok
  end

  def show
    render json: @borrowing.as_json(include: [:book, :user]), status: :ok
  end

  def create
    book = Book.find(params[:book_id])
    if current_user.borrowings.exists?(book_id: book.id)
      render json: { error: 'Already borrowed this book' }, status: :unprocessable_entity
    else
      @borrowing = Borrowing.new(user: current_user, book: book, due_at: 2.weeks.from_now, borrowed_at: Time.current)
      if @borrowing.save
        book.decrement!(:available_copies)
        render json: @borrowing, status: :created
      else
        render json: { errors: @borrowing.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    borrowing = Borrowing.find(params[:id])
    if borrowing.destroy
      render json: { message: 'Borrowing record deleted successfully' }, status: :ok
    else
      render json: { error: 'Failed to delete borrowing record' }, status: :unprocessable_entity
    end
  end

  def return
    book = @borrowing.book
    if @borrowing.returned_at.nil?
      @borrowing.update(returned_at: Time.current)
      book.increment!(:available_copies)
      render json: { message: 'Book returned successfully' }, status: :ok
    else
      render json: { error: 'Book already returned' }, status: :unprocessable_entity
    end
  end

  private

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  end

  def authorize_librarian!
    render json: { error: 'Access denied' }, status: :forbidden unless current_user.librarian?
  end
end

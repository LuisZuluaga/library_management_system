class Api::V1::BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: %i[show update destroy]
  before_action :authorize_librarian!, except: %i[index show]

  def index
    @books = Book.all

    render json: @books, status: :ok
  end

  def show; end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      render json: @book, status: :created
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    if @book.update(book_params)
      render json: @book, status: :ok
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_path, notice: 'Book deleted successfully.' }
      format.json { render json: { message: 'Book was successfully deleted.' }, status: :ok }
    end
  end
  
  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies, :available_copies)
  end

  def authorize_librarian!
    redirect_to root_path, alert: 'Access denied' unless current_user.librarian?
  end
end
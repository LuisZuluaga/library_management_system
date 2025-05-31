class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: %i[show update destroy]
  before_action :authorize_librarian!, except: %i[index show]

  def index
    @title_query = params[:title]
    @selected_author = params[:author]
    @selected_genre = params[:genre]

    @books = Book.all

    @books = @books.where("title ILIKE ?", "%#{@title_query}%") if @title_query.present?
    @books = @books.where(author: @selected_author) if @selected_author.present?
    @books = @books.where(genre: @selected_genre) if @selected_genre.present?

    @books = @books.order(created_at: :desc).paginate(page: params[:page], per_page: 10)

    @all_authors = Book.select(:author).distinct.order(:author).pluck(:author)
    @all_genres  = Book.select(:genre).distinct.order(:genre).pluck(:genre)
  end

  def show; end

  def create
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: 'Book was successfully deleted.'
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


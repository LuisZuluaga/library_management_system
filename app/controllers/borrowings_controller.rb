class BorrowingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_librarian!, except: %i[index show]

  def index
    @borrowings = Borrowing.all
  end

  def show; end

  def edit; end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def authorize_librarian!
    redirect_to root_path, alert: 'Access denied' unless current_user.librarian?
  end
end


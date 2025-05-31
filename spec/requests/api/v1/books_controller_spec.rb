# spec/requests/api/v1/books_controller_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::Books", type: :request do
  let!(:user) { create(:user) }
  let!(:book) { create(:book) }

  before do
    sign_in user  # Devise
  end

  describe "GET /api/v1/books" do
    it "returns a list of books" do
      get "/api/v1/books"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first["title"]).to eq(book.title)
    end
  end

  describe "POST /api/v1/books" do
    it "creates a book" do
      book_params = {
        book: {
          title: "New Book",
          author: "Author",
          genre: "Fiction",
          isbn: "1234567890",
          total_copies: 5
        }
      }

      expect {
        post "/api/v1/books", params: book_params
      }.to change(Book, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT /api/v1/books/:id" do
    it "updates a book" do
      updated_params = {
        book: {
          title: "Updated Book"
        }
      }
      put "/api/v1/books/#{book.id}", params: updated_params
      expect(response).to have_http_status(:ok)
      book.reload
      expect(book.title).to eq("Updated Book")
    end
  end

  describe "DELETE /api/v1/books/:id" do
    let!(:book) { create(:book) }

    it "deletes a book and returns JSON response" do
      expect {
        delete "/api/v1/books/#{book.id}", headers: { 'ACCEPT' => 'application/json' }
      }.to change(Book, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Book was successfully deleted.")
    end

    it "returns redirect response for HTML request" do
      delete "/api/v1/books/#{book.id}", headers: { 'ACCEPT' => 'text/html' }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(books_path)
      expect(flash[:notice]).to eq("Book deleted successfully.")
    end
  end
end

# spec/requests/api/v1/borrowings_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::Borrowings", type: :request do
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  before do
    sign_in user
  end

  describe "POST /api/v1/borrowings" do
    it "creates a borrowing for the user" do
      expect {
        post "/api/v1/borrowings", params: { book_id: book.id }, headers: { "ACCEPT" => "application/json" }
      }.to change(Borrowing, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["book_id"]).to eq(book.id)
    end

    it "does not allow duplicate borrowings unless returned" do
      create(:borrowing, user: user, book: book, returned_at: nil)

      post "/api/v1/borrowings", params: { book_id: book.id }, headers: { "ACCEPT" => "application/json" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq("Already borrowed this book")
    end
  end

  describe "DELETE /api/v1/borrowings/:id" do
    let!(:borrowing) { create(:borrowing, user: user, book: book) }

    it "deletes a borrowing record" do
      expect {
        delete "/api/v1/borrowings/#{borrowing.id}", headers: { "ACCEPT" => "application/json" }
      }.to change(Borrowing, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Borrowing record deleted successfully")
    end
  end

  describe "PATCH /api/v1/borrowings/:id/return" do
    let!(:borrowing) { create(:borrowing, user: user, book: book, returned_at: nil) }

    it "returns a borrowed book" do
      patch "/api/v1/borrowings/#{borrowing.id}/return", headers: { "ACCEPT" => "application/json" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Book returned successfully.")
      borrowing.reload
      expect(borrowing.returned_at).not_to be_nil
    end

    it "does not allow returning an already returned book" do
      borrowing.update(returned_at: Time.current)

      patch "/api/v1/borrowings/#{borrowing.id}/return", headers: { "ACCEPT" => "application/json" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq("Book already returned")
    end
  end
end

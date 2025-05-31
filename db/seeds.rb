# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning up database..."
Borrowing.delete_all
Book.delete_all
User.delete_all

puts "Seeding users..."
librarian = User.create!(email: "librarian@example.com", name:"Librarian", password: "password", role: "librarian")
member = User.create!(email: "member@example.com", name: "Member", password: "password", role: "member")

puts "Seeding books..."
5.times do |i|
  Book.create!(
    title: "Book #{i + 1}",
    author: "Author #{i + 1}",
    genre: ["Fiction", "Non-fiction", "Sci-fi", "Romance"].sample,
    isbn: "ISBN#{i + 1000}",
    total_copies: rand(1..5)
  )
end

puts "Seeding borrowings..."

# Overdue borrowing (due_at in the past)
Borrowing.create!(
  user: member,
  book: Book.first,
  borrowed_at: Time.now - 15.days,
  due_at: Time.now - 3.days
)

# Active borrowing (due_at in the future)
Borrowing.create!(
  user: member,
  book: Book.second,
  borrowed_at: Time.now - 2.days,
  due_at: Time.now + 5.days
)

# Another active borrowing
Borrowing.create!(
  user: member,
  book: Book.third,
  borrowed_at: Time.now - 1.day,
  due_at: Date.today.to_time.change(hour: 12)
)
puts "Done seeding!"

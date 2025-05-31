# README

Ballast Lane Test by Luis Zuluaga. https://github.com/LuisZuluaga/library_management_system#

# 1. Clone the repo
git clone https://github.com/yourusername/library_management_system.git
cd library_management_system

# 2. Install dependencies
bundle install

# 3. Set up the database
rails db:create
rails db:migrate
rails db:seed

# 5. Install Tailwind CSS (if not already installed)
rails tailwindcss:install

# 6. Run the server
rails server

## 7. Credentials
## For Librarian
user: librarian@example.com
password: password

## For Member
user: member@example.com
password: password

This project is a simple library management system built with Ruby on Rails 7, featuring authentication, role-based dashboards, and an API for managing books and borrowings.

## Why Ruby 3.2 and Rails 7?

I chose Ruby 3.2 and Rails 7 because this combination provides excellent stability and broad gem support. Ruby 3.2 is a version I’m most familiar with, which helped me work more efficiently throughout development. Rails 7’s built-in features such as Hotwire and default support for modern front-end tooling made it a solid choice for building the application quickly and reliably.

## Database: PostgreSQL
I used PostgreSQL as the database engine because it is a powerful, production-ready relational database. Its support for advanced querying makes it ideal for this kind of system, where we need to handle relationships like users, books, and borrowings efficiently.

## System Design and Models
After selecting the stack, I defined the necessary database tables and their columns. The key entities in this system are:

User (with roles: librarian and member)

Book

Borrowing (tracking borrowed books, due dates, and returns)

This planning phase was critical to ensure a normalized and scalable database structure.

## Authentication with Devise
For authentication, I integrated Devise, a widely-used and well-supported gem. I chose Devise due to time constraints and its ability to quickly scaffold registration, login, and logout views. It also handles session management securely and efficiently, making it ideal for this project.

## API Structure
To fulfill the requirement of having an API for both books and borrowings, I set up a versioned API namespace (api/v1). Here's what was implemented:

Books API: Full CRUD functionality.

Borrowings API:

Standard create (for members to borrow a book).

A custom mark_as_returned action for librarians.

This structure supports separation of concerns and future versioning.

## Dashboards per Role
Two separate dashboards were designed based on user roles:

Librarian Dashboard: Shows overdue and active borrowings, with actions to mark books as returned.

Member Dashboard: Displays the user's current and past borrowings, along with due dates.

## Books Index
I also created a common Books Index page accessible by both roles. This page conditionally displays actions based on the user's role:

Librarians can edit, delete, or mark books as returned.

Members can borrow available books.

## Search Functionality
Basic search capabilities were added:

By author

By genre

By title (partial string matching)

To support this, I created dynamic listings for genres and authors based on existing book data.

## Seeding the Database
To simulate a realistic environment, I wrote a detailed seeds.rb file:

Populates users, books, and borrowings

Includes borrowings in different states (e.g., returned, overdue, active)

This was useful for verifying dashboard logic and testing edge cases.

## Styling with Tailwind CSS
Tailwind CSS was integrated to style the application. It allowed me to design responsive, utility-first components for forms, buttons, and layout quickly. I considered integrating Vue.js for a more dynamic front-end, but due to time constraints, I kept the project fully server-rendered with Rails views.

## Testing
With the application logic complete, I added RSpec for unit and request testing. I used FactoryBot to generate consistent test data and wrote specs for:

Models (e.g., Book, Borrowing)

API controllers (api/v1/books, api/v1/borrowings)

Custom logic such as overdue detection and role-based access

This helps ensure stability and correctness of the application.

## Summary
This project represents a well-scoped Rails application with modern best practices:

Rails 7 with Ruby 3.2

PostgreSQL as the database

Devise for authentication

Role-based UI and API access

Tailwind for styling

RSpec for testing

It serves as a base for any small to mid-sized library or rental-based system and can easily be extended further with features like notifications, availability tracking, or front-end frameworks like Vue or React.

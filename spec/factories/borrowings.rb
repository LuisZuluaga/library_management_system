FactoryBot.define do
  factory :borrowing do
    association :user
    association :book
    borrowed_at { Time.now }
    due_at { Time.now + 2.weeks }
    returned_at { nil }
  end
end

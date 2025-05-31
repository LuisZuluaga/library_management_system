require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  it "is valid with valid attributes" do
    borrowing = build(:borrowing)
    expect(borrowing).to be_valid
  end

  it "sets due_at to 2 days after now by default" do
    freeze_time do
      expected_due_at = 2.days.from_now
      borrowing = build(:borrowing)
      expect(borrowing.due_at.to_i).to eq(expected_due_at.to_i)
    end
  end
end

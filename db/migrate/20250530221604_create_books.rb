class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :genre
      t.string :isbn, null: false, unique: true
      t.integer :total_copies
      t.integer :available_copies

      t.timestamps
    end
    add_index :books, :isbn, unique: true
  end
end

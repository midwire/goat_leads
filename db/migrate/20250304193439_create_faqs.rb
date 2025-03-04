class CreateFaqs < ActiveRecord::Migration[8.0]
  def change
    create_table :faqs do |t|
      t.integer :order
      t.string :question
      t.string :answer

      t.timestamps
    end
    add_index :faqs, :order, unique: true
  end
end

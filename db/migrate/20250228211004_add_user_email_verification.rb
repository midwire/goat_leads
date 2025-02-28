class AddUserEmailVerification < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :email_verified_at, :datetime, default: nil
    add_index :users, :email_verified_at
  end
end

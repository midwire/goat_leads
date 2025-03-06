class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    # licensed_states
    add_column :users, :licensed_states, :text, array: true, default: []
    add_index :users, :licensed_states, using: :gin

    # lead_status boolean
    add_column :users, :lead_status, :boolean, default: true
    add_index :users, :lead_status

    # deliver_priority - lower == higher priority (negative numbers work)
    add_column :users, :deliver_priority, :integer, default: 0
    add_index :users, :deliver_priority

    # video_type
    add_column :users, :video_types, :text, array: true, default: []
    add_index :users, :video_types, using: :gin

    # lead_types
    add_column :users, :lead_types, :text, array: true, default: []
    add_index :users, :lead_types, using: :gin

    # last_lead_delivered_at
    add_column :users, :last_lead_delivered_at, :datetime
    add_index :users, :last_lead_delivered_at
  end
end

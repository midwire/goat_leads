class AddLeadFormIdToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :lead_form_id, :string
  end
end

class RenameLeadType < ActiveRecord::Migration[8.0]
  def change
    rename_column :leads, :lead_type, :lead_quality
  end
end

class AddAdditionalLeadColumns < ActiveRecord::Migration[8.0]
  def change
    # Mortgage Protection
    add_column :leads, :health_history, :boolean
    add_column :leads, :beneficiary, :string
    add_column :leads, :beneficiary_name, :string
    add_column :leads, :mortgage_balance, :string
    add_column :leads, :mortgage_payment, :string

    # IUL
    add_column :leads, :desired_monthly_contrib, :string
    add_column :leads, :desired_retirement_age, :string

    # FEX
    add_column :leads, :amt_requested, :string
    add_column :leads, :gender, :string
    add_column :leads, :has_life_insurance, :string
    add_column :leads, :favorite_hobby, :string
    add_column :leads, :address, :string
    add_column :leads, :city, :string
    add_column :leads, :zip, :string
  end
end

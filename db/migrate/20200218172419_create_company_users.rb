class CreateCompanyUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :company_users do |t|
      t.references :user, null: false
      t.references :company, null: false
      t.timestamps
    end
  end
end

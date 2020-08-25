class CreateCompanyInvite < ActiveRecord::Migration[5.2]
  def change
    create_table :company_invites do |t|
      t.references :company, null: false
      t.string :invite_code, null: false
      t.string :status, null: false
      t.timestamps  
    end
  end
end

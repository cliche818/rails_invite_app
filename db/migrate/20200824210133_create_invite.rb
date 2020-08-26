class CreateInvite < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.references :invitable, polymorphic: true
      t.references :user
      t.string :invite_code, null: false
      t.string :status, null: false
      t.timestamps
    end

    add_index :invites, :invite_code, unique: true
  end
end

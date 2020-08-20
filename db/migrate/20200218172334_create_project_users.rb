class CreateProjectUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :project_users do |t|
      t.references :user, null: false
      t.references :project, null: false
      t.timestamps
    end
  end
end

class CreateDummyNoRoleModels < ActiveRecord::Migration
  def change
    create_table :dummy_no_role_models do |t|

      t.text :text

      t.timestamps
    end
  end
end

class CreateDummyModels < ActiveRecord::Migration
  def change
    create_table :dummy_models do |t|

      t.text :text

      t.timestamps
    end
  end
end

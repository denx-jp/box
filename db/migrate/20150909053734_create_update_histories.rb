class CreateUpdateHistories < ActiveRecord::Migration
  def change
    create_table :update_histories do |t|
      t.string :action, null: false
      t.text :path, null: false
      t.timestamps null: false
    end
  end
end

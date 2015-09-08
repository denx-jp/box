class CreateBoxFiles < ActiveRecord::Migration
  def change
    create_table :box_files do |t|
      t.string :name, null: false
      t.integer :parent_file_id, null: true
      t.boolean :is_directory, null: false
      t.integer :owner_user_id, null: false
      t.integer :permission, null: false, default: 0644
      t.timestamps null: false
    end
  end
end

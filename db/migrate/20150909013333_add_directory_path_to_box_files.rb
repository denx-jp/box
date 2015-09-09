class AddDirectoryPathToBoxFiles < ActiveRecord::Migration
  def change
    add_column :box_files, :directory_path, :text
  end
end

class AddAttachmentToBoxFiles < ActiveRecord::Migration
  def change
    add_attachment :box_files, :attachment
  end
end

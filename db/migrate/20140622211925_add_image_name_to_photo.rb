class AddImageNameToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :image_uid, :string
  end
end

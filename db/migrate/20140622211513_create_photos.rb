class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :profile_id
      t.string :name, :null => false, :limit => 100
      t.timestamps
    end
  end
end

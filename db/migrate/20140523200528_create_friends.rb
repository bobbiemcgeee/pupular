class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
    	t.integer :dog_id
    	t.integer :friend_id
    	t.boolean :is_confirmed, default: false
    	t.timestamps
    end
  end
end

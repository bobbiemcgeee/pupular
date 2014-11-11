class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
    	t.integer :dog_id
    	t.string :gender
    	t.text :photo
    	t.integer :age
    	t.string :breed
    	t.string :location
    	t.string :size
    	t.string :personality_type
    	t.string :humans_name
    	t.string :fertility
    	t.timestamps
    end
  end
end

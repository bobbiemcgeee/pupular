class CreateDogs < ActiveRecord::Migration
  def change
    create_table :dogs do |t|
    	t.integer :user_id
    	t.string :handle

		t.timestamps
    end
  end
end

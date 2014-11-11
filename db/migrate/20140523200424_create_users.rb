class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :email
    	t.string :password_digest
    	t.string :lat
    	t.string :long
		t.boolean :is_active, default: false
		t.timestamps
    end
  end
end

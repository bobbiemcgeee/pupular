class CreateSessions < ActiveRecord::Migration
 	def change
		create_table :sessions do |t| 
			t.string :sender
			t.string :receiver
			t.timestamps
		end
	end
end

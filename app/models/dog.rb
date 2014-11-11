class Dog < ActiveRecord::Base
	#attr_accesible :handle, :lat, :long, :is_active
	belongs_to :user
	has_many :friends, foreign_key: "dog_id", class_name: "Friend", dependent: :destroy
	has_many :pals, foreign_key: "friend_id", class_name: "Friend", dependent: :destroy
	has_one :profile
	has_many :sent_messages, foreign_key: "sender_id", class_name: "Message"
	has_many :received_messages, foreign_key: "receiver_id", class_name: "Message"	
end
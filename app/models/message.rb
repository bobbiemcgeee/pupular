class Message < ActiveRecord::Base
	belongs_to :sender, class_name: "Dog"
	belongs_to :receiver, class_name: "Dog"
end
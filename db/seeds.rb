# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

100.times do
	username = Faker::Internet.user_name
	handle = Faker::Internet.user_name
	password = "password"
	name = Faker::Name.name
	email = Faker::Internet.email
	user = User.create(email: email, password: password)
	dog = user.dogs.create(handle: handle, lat:"32.43", long:"44.33")
  	dog.profile = profile
end

User.create(email:"hoopmiester@aol.com", password: "oreodog")


5.times do 
	dog_id = 101
	friend_id = rand(100)
	friendship = Friend.create(dog_id:dog_id, friend_id:friend_id, is_confirmed:true)
end


5.times do 
	dog_id = 101
	friend_id = rand(100)
	friendship = Friend.create(dog_id:dog_id, friend_id:friend_id, is_confirmed:false)
end
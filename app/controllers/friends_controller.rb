class FriendsController < ApplicationController

	def index
	end

	def create
	end

	def update
	end

	def show
	end

	def delete
	end

	def is_friend
		@existing_friendship = Friend.where(dog_id:params[:dog_id],friend_id:params[:friend_id]).first
		@existing_friendship2 = Friend.where(dog_id:params[:friend_id],friend_id:params[:dog_id]).first
		if(@existing_friendship || @existing_friendship2)
			@is_friend = true
		else	
			@is_friend = false
		end
		render :json => {:is_friend => @is_friend}

	end

	def friend_request
		@dog = Dog.find(params[:dog_id])
		@friend = Dog.find(params[:friend_id])
		@existing_friendship = Friend.where(dog_id:params[:dog_id],friend_id:params[:friend_id]).first
		@existing_friendship2 = Friend.where(dog_id:params[:friend_id],friend_id:params[:dog_id]).first
		if(@existing_friendship || @existing_friendship2)
		else
		Friend.create(dog_id:params[:dog_id], friend_id:params[:friend_id], is_confirmed:false)
		Message.create(sender_id:params[:dog_id], receiver_id:params[:friend_id],message_type:"friend_request",body:@dog.handle + " wants to run in your pack!")
		Message.create(sender_id:params[:friend_id], receiver_id:params[:dog_id],message_type:"auto_message", read: true, body:"Pending pack request with " + @friend.handle)
		end
		render :json => {:response => "friend request sent"}
	end

	def accept_request
		request_author = Dog.find(params[:dog_id])
		request_receiver = Dog.find(params[:friend_id])
		@friend = Friend.where(dog_id:params[:dog_id],friend_id:params[:friend_id]).first
		@friend.is_confirmed = true
		@friend.save!
		@message = Message.where(message_type:"friend_request",sender_id:params[:dog_id],receiver_id:params[:friend_id]).first
		if @message
			@message.destroy
		end
		@message = Message.where(message_type:"auto_message",sender_id:params[:friend_id],receiver_id:params[:dog_id],body:"Pending pack request with " + request_receiver.handle).first
		if @message
			@message.destroy
		end
		Message.create(sender_id:params[:dog_id],receiver_id:params[:friend_id],message_type:"auto_message", read: true, body:"You and " + request_author.handle + " are now in a pack." )
		Message.create(sender_id:params[:friend_id],receiver_id:params[:dog_id],message_type:"request_accepted",  body:"You and " + request_receiver.handle + " are now in a pack." )

		render :json => {:response => "friend request accepeted"}
	end

	def decline_request
		@dog = Dog.find(params[:friend_id])
		@declined_friend = Dog.find(params[:dog_id])
		@friendship_pending_message = Message.where(sender_id:params[:friend_id],receiver_id:params[:dog_id],message_type:"auto_message").first
		if @friendship_pending_message
			@friendship_pending_message.destroy!
		end
		@request_message = Message.where(sender_id:@declined_friend.id,receiver_id:@dog.id,message_type:"friend_request").first
		if @request_message
			@request_message.destroy!
		end
		@friend = Friend.where(dog_id:params[:dog_id], friend_id:params[:friend_id], is_confirmed:false).first
		@friend.destroy
		render :json => {:response => "friend request declined"}
	end

	def friend_list
		@dog = Dog.find(params[:dog_id])
		ids = []
		active_ids = []
		@dog.friends.each do |friend| 
			if friend.is_confirmed == true
				ids << friend.friend_id
			end 
		end
		@dog.pals.each do |friend| 
			if friend.is_confirmed == true
				ids << friend.dog_id
			end 
		end		
		ids.uniq!
		ids.each do |id|
			@this_dog = Dog.find(id)
			if (@this_dog.user.is_active == true) && ((Time.now - @this_dog.user.updated_at) < 30)
				active_ids << id
			end
		end
		render json: {friends: ids, active: active_ids}
	end

	def delete_friendship
		@dogFriend = Dog.find(params[:friendship_id])
		@dog = Dog.find(params[:dog_id])
		@friendship = Friend.where(friend_id:@dogFriend.id,dog_id:@dog.id).first
		@pal = Friend.where(dog_id:@dogFriend.id,friend_id:@dog.id).first
		if @friendship
			@friendship.destroy!
		end
		if @pal
			@pal.destroy!
		end
		render :json => { :response_message => "friendship deleted"}
	end

end

	class MessagesController < ApplicationController

	def index
	end

	def create
		message_receiver = Dog.find(params[:receiver_id])
		Message.create(sender_id:params[:sender_id],receiver_id:message_receiver.id,message_type:params[:message_type],body:params[:body])
		#Message.create(sender_id:params[:sender_id],receiver_id:params[:sender_id],message_type:"auto_message",body:params[:body])
		render :json => {:message => "message sent!"}
	end

	def update
	end

	def show
	end

	def delete
	end

	def walk_alert
		p "Walk alert sent"
		@dog = Dog.find(params[:dog_id])
		@user = @dog.user
		@user.is_active = true
		@user.update_attribute(:updated_at, Time.now);
		@user.save!
		@dog.sent_messages.each do |sent_message|
			if sent_message.message_type == "walk_alert"
				sent_message.destroy!
			end
		end
		@dog.friends.each do |friend|
			if friend.is_confirmed == true
			@dog.sent_messages.create(
				receiver_id: friend.friend_id, 
				message_type:"walk_alert",
				body:"#{@dog.handle} is wagging and ready to play!")
			end
		end
		@dog.pals.each do |pal|
			if pal.is_confirmed == true
				p "okay its offic	"
			@dog.sent_messages.create(
				receiver_id: pal.dog_id,
				message_type:"walk_alert",
				body:"#{@dog.handle} is wagging and ready to play!")
			end
		end
		render :json => { :walk_alert => "succesfully sent"}
	end

	def conversation
		@dog = Dog.find(params[:dog_id])
		@final_messages = Array.new
		@sent_messages = @dog.sent_messages.where(receiver_id:params[:friend_id])
		@received_messages = @dog.received_messages.where(sender_id:params[:friend_id])
		total_messages = @received_messages + @sent_messages
		messages_count = total_messages.count
		sorted_messages = total_messages.sort_by {|obj| obj.created_at}

		if messages_count > 10
			revised_messages = sorted_messages.pop(10)
			revised_messages.each do |message|
				if message.message_type == "friend_request" || message.message_type == "walk_alert" || message.message_type == "auto_message" || message.message_type == "request_accepted"
				else
					@final_messages << message
				end
			end
		else
			sorted_messages.each do |message|
				if message.message_type == "friend_request" || message.message_type == "walk_alert" || message.message_type == "auto_message" || message.message_type == "request_accepted"
				else
					@final_messages << message
				end
			end			
		end
		render :json => {:total_convo => @final_messages}

	end

	def all_messages
		@dog = Dog.find(params[:dog_id])
		final_messages = Array.new
		@messages = @dog.received_messages + @dog.sent_messages
		all_convo_pairs = Array.new
		cloned_messages = @messages.clone.uniq
		@all_messages = Array.new
		cloned_messages.each do |message|
			message = message.clone
			@sender_dog = Dog.find(message.sender_id)
			@receiver_dog = Dog.find(message.receiver_id)
			if message.sender_id == @dog.id
				@profile = @receiver_dog.profile
				@display_handle = @receiver_dog.handle
			else
				@profile = @sender_dog.profile
				@display_handle = @sender_dog.handle
			end
			@photo = Photo.where(profile_id:@profile.id).last
			if @photo
				@url = Dragonfly.app.remote_url_for(@photo.image_uid)
			else
				@url = "none"
			end

			if message.message_type == "walk_alert"
				if message.sender_id == @dog.id
					next
				else
					@walking_dog = Dog.find(message.sender_id)
					if ((Time.now - @walking_dog.user.updated_at) > 30)
						next
					end
				end

			elsif message.message_type == "friend_request"
				if message.sender_id == @dog.id
					next
				end
			elsif message.message_type == "auto_message"
				if message.sender_id == @dog.id
					next
				end
			elsif message.message_type == "request_accepted"
				if message.sender_id == @dog.id
					next
				end
			elsif message.sender_id == @dog.id
				#message.read = true
			end
			@all_messages << [message, @display_handle, @url]
		end
		## organize conversations
		sorted_messages = @all_messages.sort_by {|obj| obj[0].created_at}.reverse
		sorted_messages.each do |message|
			if message[0].message_type == "message"
				convo_pair = [message[0].sender_id, message[0].receiver_id].sort
				if all_convo_pairs.include?(convo_pair)
				else
					final_messages << message
					all_convo_pairs << convo_pair
				end	
			elsif message[0].message_type == "auto_message" || message[0].message_type == "request_accepted" || message[0].message_type == "friend_request" || message[0].message_type == "walk_alert"
				final_messages << message
			end
		end
		render :json => { :messages => final_messages}
	end



	def has_been_read
		@message = Message.find(params[:message_id])
		@message.update_attribute(:read, true)
		@message.save!
		p "hey it was read"
	end

	def delete_message

		@message = Message.find(params[:message_id])
		if @message.message_type == "message"

		else
			@message.destroy!
		end
		render :json => { :response_message => "message deleted"}

	end

end

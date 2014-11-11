require 'dragonfly'
require 'aws-sdk'
class UsersController < ApplicationController
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


	def sign_up
		email = params[:email]
		zip = params[:zip]
		password = params[:password]
		password_confirm = params[:passwordConfirm]
		handle = params[:handle];
		@existing_handle = Dog.where(handle:handle).first
		if email == "" || zip == "" || password == "" || password_confirm == ""|| handle == ""
			render :json => {login_status: "failure", reason: "All fields are required."}
		elsif @existing_handle
			render :json => {login_status: "failure", reason: "This handle is taken."}
		elsif password != password_confirm 
			render :json => {login_status: "failure", reason: "Your passwords don't match."}
		elsif zip.length != 5
			render :json => {login_status: "failure", reason: "You must eneter a valid 5 digit zip code."}
		else
		@user = User.create(email:params[:email],password:params[:password])
		@dog = @user.dogs.create(handle:params[:handle])
		File.open(@dog.handle + '.png', 'wb') do|f|
			f.write(Base64.decode64(params[:photo]))
			p "okay"
		end
			#s3 = AWS::S3.new
			#s3.buckets["pupular"].objects[@dog.handle].write(:file => File.open(@dog.handle + '.png'))
			#@url = s3.buckets["pupular"].objects["huge"].public_url
			file = File.open(@dog.handle + '.png')
			p "before"
			uid = Dragonfly.app.store(file, path: '#{@dog.handle}', headers: {'x-amz-acl' => 'public-read-write'})
			p "after"
			@profile = Profile.new
			@dog.profile = @profile
			@profile.location = params[:zip]

			@profile.save!
			p "even here"
			@photo = Photo.new
			file = File.open(@dog.handle + '.png')
			@photo.image_uid = uid
			@photo.profile_id = @dog.profile.id
			@photo.name = @dog.handle
			@photo.image_name = @dog.handle + ".png"
			@photo.save!
			@url = Dragonfly.app.remote_url_for(uid)
			image = Dragonfly.app.fetch(uid).thumb('50x50')
			thumb_file = image.to_file('#{@dog.handle}_thumb.png')
			thumb_uid = Dragonfly.app.store(thumb_file, path: '#{@dog.handle}_thumb', headers: {'x-amz-acl' => 'public-read-write'})
			@url = Dragonfly.app.remote_url_for(uid)
			@thumb_url = Dragonfly.app.remote_url_for(thumb_uid)
			@thumb_photo = Photo.new
			@thumb_photo.image_uid = thumb_uid
			@thumb_photo.profile_id = @dog.profile.id
			@thumb_photo.name = @dog.handle + "_thumb"
			@thumb_photo.name = @dog.handle + "_thumb.png"
			@thumb_photo.save!
		@dog.save!
		@user.save!
		render :json => { :login_status => "success" , :email => @user.email, :dog_id => @dog.id, :dog_handle => @dog.handle, :dog_url => @thumb_url}
		end
	end

	def login
		params.require(:user).permit(:email, :password)

		@user = User.where(email: params[:email]).first
		if @user && @user.authenticate(params[:password])
			@dog = @user.dogs.first
			@profile = @dog.profile
			@photo = Photo.where(profile_id:@profile.id).last
			if @photo
				@url = Dragonfly.app.remote_url_for(@photo.image_uid)
			else
				@url = "none"
			end
			render :json => { :login_status => "success" , :email => @user.email, :dog_id => @dog.id, :dog_handle => @dog.handle, :dog_url => @url }
		else
			render :json => { :login_status => "failed"}
		end

	end

	def update_coordinates
		@user = User.where(email: params[:email]).first
		@user.lat = params[:lat]
		@user.long = params[:long]
		@user.update_attribute(:is_active, true);
		@user.update_attribute(:updated_at, Time.now);
		@user.save!
	end

	def deactivate
		p "not walk"
		@user = User.where(email: params[:email]).first
		@dog = @user.dogs.first
		p @dog.handle
		@walk_alerts = @dog.sent_messages.where(message_type:"walk_alert")
		@walk_alerts.each do |message|
			message.destroy!
		end
		@user.update_attribute(:is_active, false);
		@user.save!
		render :json => {:deactivated => "true"}
	end

	def retrieve_active_friends
		@dog = Dog.find(params[:dog_id])
		@friends = Friend.where(dog_id:@dog.id)
		@pals = Friend.where(friend_id:@dog.id)
		all_friends = Array.new()
		@friends.each do |friend|
			if friend.is_confirmed == true
			other_dog = Dog.find(friend.friend_id)
				if (other_dog.user.is_active == true) && ((Time.now - other_dog.user.updated_at) < 30)
					@profile = other_dog.profile
					if params[:small_photo]
						@photo = Photo.where(profile_id:@profile.id).last
					else
						@photo = Photo.where(profile_id:@profile.id).first
					end
					if @photo
						@url = Dragonfly.app.remote_url_for(@photo.image_uid)
					else
						@url = "none"
					end
				all_friends << {photo: @url, handle: other_dog.handle, id: other_dog.id, lat: other_dog.user.lat, long: other_dog.user.long}
				end
			end
		end
		@pals.each do |friend|
			if friend.is_confirmed == true
				other_dog = Dog.find(friend.dog_id)
				if (other_dog.user.is_active == true) && ((Time.now - other_dog.user.updated_at) < 30)
					@profile = other_dog.profile
					if params[:small_photo]
						@photo = Photo.where(profile_id:@profile.id).last
					else
						@photo = Photo.where(profile_id:@profile.id).first
					end
					if @photo
						@url = Dragonfly.app.remote_url_for(@photo.image_uid)
					else
						@url = "none"
					end
					all_friends << {photo: @url, handle: other_dog.handle, id: other_dog.id,lat: other_dog.user.lat, long: other_dog.user.long}
				end
			end
		end

		render :json => { :active_friends_list => all_friends}
	end
end



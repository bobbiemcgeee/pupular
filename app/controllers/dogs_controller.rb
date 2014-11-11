require 'dragonfly'

class DogsController < ApplicationController
	#params.require(:dog).permit(:friends, :pals,:password)

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

	def dog_photo
			@dog = Dog.find(params[:dog_id])
				@profile = @dog.profile
				@handle = @dog.handle
				@photo = Photo.where(profile_id:@profile.id).last
				if @photo
					@url = Dragonfly.app.remote_url_for(@photo.image_uid)
				else
					@url = "none"
				end
					render :json =>  {photo: @url, handle: @handle, profile: @profile}
			else
	end


	def all_dogs
		all_dogs = {}
		photo_urls = []
		Dog.all.each {|x| all_dogs[x.id] = x}
		Photo.all.each {|x| photo_urls << [x.profile_id,x.image_uid] }
		photo_urls.each {|url| url[1] = Dragonfly.app.remote_url_for(url[1])}
		all_dogs.each do |id, dog|
			attributes = dog.attributes
			photo_list = []
			photo_urls.each do |url_array|
				if url_array[0] == dog.profile.id
					photo_list << url_array[1]
				end
			end
			attributes['profile'] = dog.profile
			attributes['photo_list'] = photo_list
			@dog = Dog.find(id)
			ids = []
			@dog.friends.each {|friend| ids << friend.friend_id }
			@dog.pals.each {|pal| ids << pal.dog_id }
			ids.uniq!
			attributes['friend_ids'] = ids
			all_dogs[id] = attributes
		end
		render :json => {all_dogs: all_dogs}
	end

	def profile
		@dog = Dog.find(params[:dog_id])
		render :json => {:profile => @dog.profile}
	end

	def retrieve_profile_photo
		@dog = Dog.find(params[:dog_id])
		@profile = @dog.profile
			@photo = Photo.where(profile_id:@profile.id).first
			@url = Dragonfly.app.remote_url_for(@photo.image_uid)
		render :json => {:profile_photo => @url}
	end
end

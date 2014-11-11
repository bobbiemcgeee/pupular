require 'dragonfly'

class ProfilesController < ApplicationController

	def add_photo
		#params.require(:profile).permit(:photo)

		@dog = Dog.find(params[:dog_id])
		photo_string = params[:photo_string]
		File.open('testImage.png', 'wb') do|f|
  		f.write(Base64.decode64(photo_string))
		end
		@profile = @dog.profile
		@profile.photo = photo_string
		@profile.save!
		render :json => {:status => "gimme"}
	end

	def view_photo

		@image = Dragonfly.app.remote_url_for('https://s3.amazonaws.com/pupular/sweetjowns')
	end

  def new_profile
    @photo = Photo.new
  end

  def create_profile
   @photo.update_attributes(params[:photo])
 end

 def edit_profile
 	@dog = Dog.find(params[:dog_id])
 	@profile = @dog.profile
	@profile.fertility = params[:spayed]
	@profile.breed = params[:breed]
	@profile.size = params[:size]
	@profile.age = params[:age]
	@profile.gender = params[:gender]
	@profile.personality_type = params[:personality]
	@profile.humans_name = params[:owner]
	@profile.location = params[:zip]
	@profile.save!
	if params[:photo] != "none"
		@existing_photos = Photo.where(profile_id:@dog.profile.id)
		@existing_photos.each do |photo|
			photo.destroy!
		end
		File.open(@dog.handle + '.png', 'wb') do|f|
			f.write(Base64.decode64(params[:photo]))
		end
			@photo = Photo.new
			file = File.open(@dog.handle + '.png')
			uid = Dragonfly.app.store(file, path: '#{@dog.handle}', headers: {'x-amz-acl' => 'public-read-write'})
			@photo.image_uid = uid
			@photo.profile_id = @dog.profile.id
			@photo.name = @dog.handle
			@photo.image_name = @dog.handle + ".png"
			@photo.save!
			@url = Dragonfly.app.remote_url_for(uid)
			image = Dragonfly.app.fetch(uid).thumb('50x50')
			thumb_file = image.to_file('#{@dog.handle}_thumb.png')
			thumb_uid = Dragonfly.app.store(thumb_file, path: '#{@dog.handle}_thumb', headers: {'x-amz-acl' => 'public-read-write'})
			@thumb_url = Dragonfly.app.remote_url_for(thumb_uid)
			@thumb_photo = Photo.new
			@thumb_photo.image_uid = thumb_uid
			@thumb_photo.profile_id = @dog.profile.id
			@thumb_photo.name = @dog.handle + "_thumb"
			@thumb_photo.name = @dog.handle + "_thumb.png"
			@thumb_photo.save!	
	else
		@url = "none"
		@thumb_url = "none"
	end
	render :json => {:profile_update => "success", :dog_thumb_url => @thumb_url, :dog_url => @url}
 end

end

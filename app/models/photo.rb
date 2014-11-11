class Photo < ActiveRecord::Base
  # attr_accessible :image, :name, :image_uid

  #defines which column houses the image file
  dragonfly_accessor :image

  #associations
  belongs_to :profile, foreign_key: "profile_id"
end

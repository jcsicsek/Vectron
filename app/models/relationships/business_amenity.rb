class BusinessAmenity < ActiveRecord::Base
  belongs_to :amenity
  belongs_to :business
end

class Airport < ActiveRecord::Base
  attr_accessible :city, :code, :latitude, :longitude, :name, :timezone
end

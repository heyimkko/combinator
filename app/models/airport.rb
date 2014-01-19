class Airport < ActiveRecord::Base
  attr_accessible :city, :code, :latitude, :longitude, :name, :timezone

  def self.departure_airports
    [
      # Airport.find_by_code("LAX"),
      Airport.find_by_code("SFO")
    ]
  end

  def self.destination_airports
    [
      Airport.find_by_code("LAS"),
      Airport.find_by_code("LAX"),
      Airport.find_by_code("PDX"),
      Airport.find_by_code("SAN"),
      Airport.find_by_code("SFO")
    ]
  end
end

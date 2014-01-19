class Flight
  def self.find_with_departure_code(departure_code)
    conn = Faraday.new(:url => "http://fs-#{departure_code}-api.herokuapp.com") do |faraday|
    # conn = Faraday.new(:url => "http://localhost:3001") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    conn
  end
end
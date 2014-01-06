class FlightsController < ApplicationController
  def results
    flights = []
    departure_airports.each do |dep_ap|
      destination_airports.each do |des_ap|
        conn = faraday_connection(dep_ap.code)
        params_to_send = default_params(dep_ap.id, des_ap.id)
        raw_results = conn.get "/filter", params_to_send
        results = JSON.parse(raw_results.body)
        flights << results["flights"] if results["flights"].any?
      end
    end
    @flights = flights.flatten
  end

  private

  def faraday_connection(departure_code)
    conn = Faraday.new(:url => "http://fs-#{departure_code}-api.herokuapp.com") do |faraday|
    # conn = Faraday.new(:url => "http://localhost:3001") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    conn
  end

  def default_params(from, to)
    {
      :password => ENV['POST_PASSWORD'],
      :passed_params => {
        "sort" => "Price",
        "dates" => "Jan 1, 2014 - Mar 31, 2014",
        "type" => "Epic",
        "from" => from,
        "to" => to,
        "page" => 1
      }.to_s
    }
  end

  def departure_airports
    [
      Airport.find_by_code("LAX"),
      Airport.find_by_code("SFO")
    ]
  end

  def destination_airports
    [
      Airport.find_by_code("LAS"),
      Airport.find_by_code("LAX"),
      Airport.find_by_code("PDX"),
      Airport.find_by_code("SAN"),
      Airport.find_by_code("SFO")
    ]
  end
end
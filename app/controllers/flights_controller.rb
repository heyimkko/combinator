class FlightsController < ApplicationController
  def results
    respond_to do |format|
      flights = []
      departure_airports.each do |dep_ap|
        destination_airports.each do |des_ap|
          next if dep_ap == des_ap
          conn = Flight.find_with_departure_code(dep_ap.code)
          params_to_send = default_params(dep_ap.id, des_ap.id)
          raw_results = conn.get "/filter", params_to_send
          results = JSON.parse(raw_results.body)
          flights << results["flights"] if results["flights"].any?
        end
      end
      format.json { render :json => { :results => render_to_string('_results.haml', :locals => { :flights => flights.flatten }) } }
    end
  end

  private

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
    Airport.departure_airports
  end

  def destination_airports
    Airport.destination_airports
  end
end
class DealsController < ApplicationController
  def results
    respond_to do |format|
      deals = []
      origin = "LAX"
      destination = "los-angeles"
      conn = faraday_connection
      raw_results = conn.get "/v2/deals.json", params_to_send(destination)
      results = JSON.parse(raw_results.body)["deals"]
      deals << valid_results(results, origin)
      format.json { render :json => { :results => render_to_string('_results.haml', :locals => { :deals => deals.flatten }) } }
    end
  end

  def faraday_connection
    conn = Faraday.new(:url => "https://api.groupon.com") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    conn
  end

  def valid_results(response, origin)
    valid_packages = []
    response.each do |deal|
      next if is_sold_out?(deal)
      begin
        location = deal["redemptionLocation"]
        city = deal["options"].first["redemptionLocations"].first["city"]
        location_name = deal["options"].first["redemptionLocations"].first["name"]
        package_title = deal["announcementTitle"]
      rescue NoMethodError => e
        next
      end
   
      if airport_to_destination[origin].include?(city)
        valid_packages << {
          :location => location,
          :city => city,
          :location_name => location_name,
          :package_title => package_title
        }
      end
    end
    return valid_packages
  end
   
  def is_sold_out?(deal)
    deal["isSoldOut"]
  end

  def params_to_send(destination)
    {
      :client_id => ENV['GROUPON_CLIENT_ID'],
      :channel_id => "getaways",
      :division_id => destination
    }
  end

  def airport_to_destination
    {
      "LAS" => ["Las Vegas"],
      "LAX" => ["Los Angeles", "Santa Monica", "Anaheim", "Malibu"],
      "PDX" => ["Portland"],
      "SAN" => ["San Diego"],
      "SFO" => ["San Francisco", "Napa"]
    }
  end
end
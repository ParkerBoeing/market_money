class NearestAtmService

  def nearest_atms(market)
    get_url("?key=#{ENV['TOMTOM_API_KEY']}&lat=#{market.lat}&lon=#{market.lon}&category=ATM")
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: 'https://api.tomtom.com/search/2/nearbySearch/.json')
  end
end

class NearestAtmService

  def nearest_atms(market)
    get_url("?key=#{Rails.application.credentials.tomtom_api_key[:key]}&lat=#{market.lat}&lon=#{market.lon}&categorySet=7397")
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: 'https://api.tomtom.com/search/2/nearbySearch/.json')
  end
end

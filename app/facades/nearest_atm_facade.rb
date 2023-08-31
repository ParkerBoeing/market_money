class NearestAtmFacade
  def self.nearby_atms(market)
    service = NearestAtmService.new
    require 'pry'; binding.pry
    raw_atms = service.nearest_atms(market)[:results]
    raw_atms.map do |raw_atm|
      NearestAtm.new()
    end
  end
end
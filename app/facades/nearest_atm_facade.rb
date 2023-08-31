class NearestAtmFacade
  def self.nearby_atms(market)
    service = NearestAtmService.new
    raw_atms = service.nearest_atms(market)[:results]
    atms = raw_atms.map do |raw_atm|
            NearestAtm.new(name: raw_atm[:poi][:name],
                     address: raw_atm[:address][:freeformAddress],
                     distance: raw_atm[:dist],
                     lat: raw_atm[:position][:lat],
                     lon: raw_atm[:position][:lon]
                    )
    end

    sorted_atms = atms.sort_by(&:distance)
    sorted_atms
  end
end
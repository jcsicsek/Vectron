class MigrateVenues
  def self.migrate
    Business.all.each do |business|
      venue = Venue.new
      venue.name = business.name
      venue.street_address = business.street_address
      venue.street_address_2 = business.street_address_2
      venue.city_address = business.city_address
      venue.state = business.state
      venue.zip_code = business.zip_code
      venue.phone_number = business.phone_number
      venue.neighborhood = business.neighborhood
      venue.business_id = business.id
      venue.active = true
      venue.save
      business.vouchers.each do |voucher|
        voucher.venue_id = venue.id
        voucher.save
      end
      business.event_templates.each do |event_template|
        event_template.venue_id = venue.id
        event_template.save
      end
    end
  end
end

class MigrateTicketCutoff
  def self.migrate
    Business.all.each do |business|
      business.ticket_cutoff = 30
      business.save
    end
    Voucher.all.each do |voucher|
      voucher.ticket_cutoff = 30
      voucher.save
    end
    EventTemplate.all.each do |event_template|
      event_template.ticket_cutoff = 30
      event_template.save
    end
  end
end

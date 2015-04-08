class City < ActiveRecord::Base
  def format_url
    '/' + self.name.gsub(" ", "-").gsub(",", "").downcase
  end
end

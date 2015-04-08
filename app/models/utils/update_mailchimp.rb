class UpdateMailchimp
  def self.update
    begin
      h = Hominid::API.new('d137a9c632d0872efebac6cb506ade63-us2')
      if Rails.env.production?
        list_id = h.find_list_id_by_name('Signups')
      else
        list_id = h.find_list_id_by_name('Development')
      end
    rescue
    end
    
    User.all.each do |user|
      begin
        if (user.city_id)
          city_name = user.city.name
        else
          city_name = "New York City"
        end
        h.list_update_member(list_id, user.email, {'CITY' => city_name, 'FNAME' => user.first_name.to_s, 'LNAME' => user.last_name.to_s}, 'html', false)
      rescue
      end
    end
    
    Subscriber.all.each do |subscriber|
      begin
        if (subscriber.city_id)
          city_name = subscriber.city.name
        else
          city_name = "New York City"
        end
        h.list_update_member(list_id, subscriber.email.to_s, {'CITY' => city_name}, 'html', false)
      rescue
      end
    end
    
    begin
      if Rails.env.production?
        list_id = h.find_list_id_by_name('Businesses')
      else
        list_id = h.find_list_id_by_name('Development Business')
      end
    rescue
    end
    
    Business.all.each do |business|
      begin
        if (business.city_id)
          city_name = business.city.name
        else
          city_name = business.city_address.to_s
        end
        h.list_update_member(list_id, business.email, {'CITY' => city_name, 'FNAME' => business.first_name, 'LNAME' => business.last_name, 'VENUE' => business.name}, 'html', false)
      rescue
      end
    end
    
  end
end
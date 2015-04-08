class PagesController < ApplicationController

  def coming_soon
    @city_name = params[:city_name]
    @city_name = @city_name.split("-").each{|word| word.capitalize!}.join(" ")
    @active_cities = City.find_all_by_active(true)
  end
  
  def about
    @title = "About | UsherBuddy, Last-Minute Event Tickets"
  end
  
  def abuse
    @title = "Report Abuse | UsherBuddy, Last-Minute Event Tickets"
  end
  
  def contact
    @title = "Contact | UsherBuddy, Last-Minute Event Tickets"
  end
  
  def deal
    @title = "Events | UsherBuddy, Last-Minute Event Tickets"
  end
  
  def dev
    @title = "Develop | UsherBuddy, Last-Minute Event Tickets"
  end
  
  def jobs
    @title = "Careers | UsherBuddy, Last-Minute Event Tickets"
  end
  
  def press
    @title = "Press | UsherBuddy, Last-Minute Event Tickets"
  end
  
  def privacy
    @title = "Privacy | UsherBuddy, Last-Minute Event Tickets"
  end
  
  def terms
    @title = "Terms & Conditions | UsherBuddy, Last-Minute Event Tickets"
  end
  
end

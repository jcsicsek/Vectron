class LandingController < ApplicationController
  layout false
  
  def save_preferences
    responds_to_parent do
      redirect_to root_path
    end
  end
  
  def preferences
    if (user_signed_in?)
      @subscriber = current_user.subscriber
    elsif (cookies[:subscriber_id] && Subscriber.exists?(cookies[:subscriber_id]))
      @subscriber = Subscriber.find(cookies[:subscriber_id])
    else
      @subscriber = Subscriber.create
    end
    @subscriber.email_schedule.build
  end
  
  def promo
    if (params[:name] && Promo.exists?(:name => params[:name]))
      cookies[:promo] = Promo.find_by_name(params[:name]).id
    end
    redirect_to root_path
  end
  
  def show
    if (params[:share])
      cookies[:referral_code] = params[:share]
    end
    if (current_user)
      redirect_to '/new-york-city'
    elsif (current_business)
      redirect_to business_root_path
    elsif (cookies[:user_id])
      if (User.exists?(cookies[:user_id]))
        if (User.find(cookies[:user_id]).city)
          redirect_to User.find(cookies[:user_id]).city.format_url
        else
          redirect_to home_path
        end
      else
        cookies.delete(:user_id)
      end
    elsif (cookies[:subscriber_id])
      if (Subscriber.exists?(cookies[:subscriber_id]))
        redirect_to Subscriber.find(cookies[:subscriber_id]).city.format_url
      else
        cookies.delete(:subscriber_id)
        redirect_to home_path
      end
    elsif (cookies[:business_id])
      redirect_to business_landing_path
    end
    
    @subscriber = Subscriber.new
  end
  
  def create_subscriber
    @subscriber = Subscriber.new(params[:subscriber])
    if (cookies[:promo])
      @subscriber.promo_id = cookies[:promo]
    end
    @subscriber.save
    cookies.permanent[:subscriber_id] = @subscriber.id
    
    begin
      h = Hominid::API.new('d137a9c632d0872efebac6cb506ade63-us2')
      if Rails.env.production?
        list_id = h.find_list_id_by_name('Signups')
      else
        list_id = h.find_list_id_by_name('Development')
      end
      h.list_subscribe(list_id, @subscriber.email, {'CITY' => @subscriber.city.name}, 'html', false, false, false, false)
    rescue
    end
    
    Emailer.welcome(@subscriber).deliver
    
    redirect_to @subscriber.city.format_url
  end
  
  def unsubscribe
    subscriber = Subscriber.find_by_email(params[:email])
    
    begin
      h = Hominid::API.new('d137a9c632d0872efebac6cb506ade63-us2')
      list_id = h.find_list_id_by_name('Signups')
      h.list_unsubscribe(list_id, subscriber.email, false, false, true)
    rescue
    end
    
    if (cookies[:subscriber_id])
      cookies.delete(:subscriber_id)
    end
    subscriber.delete
    flash[:notice] = "You have been unsubscribed from the UsherBuddy mailing list."
    redirect_to '/new-york-city'
  end
  
end

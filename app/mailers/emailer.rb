class Emailer < ActionMailer::Base
  #default :from => "Dogs Poop Outdoors"
  
  def welcome(subscriber)
    @subject = "Welcome to UsherBuddy!"
    @facebook_url = "http://www.facebook.com/share.php?u=" + "http://www.usherbuddy.com"
    @twitter_url = "http://twitter.com/home?status=" + URI.escape("Join me with @UsherBuddy for great last-minute theatre, music, comedy, & more ticket deals! http://www.usherbuddy.com")
    @base_url = "http://www.usherbuddy.com"
    @account_url = "http://www.usherbuddy.com/users/new/"
    @email = subscriber.email
    @unsubscribe_url = unsubscribe_url(:email => @email)
    @city = subscriber.city.name
    
    mail(:to => @email,
         :from => "Buddy <buddy@usherbuddy.com>",
         :subject => @subject)
  end
 
  def receipt(voucher_offer)
    
    #FOR DEBUGGING PURPOSES
    if (voucher_offer.is_a?(String))
      @event_tagline = "Test Event at Test Venue in Test Neighborhood"
      @subject = "UsherBuddy Receipt for " + @event_tagline
      @to = voucher_offer
      @first_name = "Test User"
      @quantity = 3
      @price = "$30.00"
      @facebook_url = ""
      @twitter_url = ""
      @payment_details = "$1.00 from Credit Card XXXX-XXXX-XXXX-1234"
      @account_url = "https://www.usherbuddy.com/account"
      @deal_link = "http://www.usherbuddy.com/"
      @voucher_code = "123-45-6789"
      @referral_url = @deal_link
    else
      @user = voucher_offer.user
      @referral_url = voucher_offer.voucher.share_url(@user.id)
      @event_tagline = voucher_offer.voucher.format_title
      @subject = "UsherBuddy Receipt for " + @event_tagline
      @to = voucher_offer.user.email
      @first_name = voucher_offer.user.first_name
      @quantity = voucher_offer.quantity
      @price = voucher_offer.voucher.format_total_price(@quantity)
      @facebook_url = voucher_offer.voucher.facebook_url(@user.id)
      @twitter_url = voucher_offer.voucher.twitter_url(@user.id)
      if (voucher_offer.amount_from_payment.to_i <= 0)
        @payment_details = voucher_offer.format_amount_from_balance + " in UsherBuddy Credit"
      else
        if (voucher_offer.payment_profile)
          @payment_details = voucher_offer.format_amount_from_payment + " from credit card " + voucher_offer.payment_profile.get_cc_number
        else
          @payment_details = voucher_offer.format_amount_from_payment + " from your PayPal account"
        end
        if (voucher_offer.amount_from_balance.to_i > 0)
          @payment_details += ", " + voucher_offer.format_amount_from_balance + " in UsherBuddy Credit"
        end
      end
      @account_url = "https://www.usherbuddy.com/account"
      @deal_link = "http://www.usherbuddy.com/deal/" + voucher_offer.voucher.id.to_s
      @voucher_code = voucher_offer.ticket_id
    end
    
    mail(:to => @to,
         :from => "Buddy <buddy@usherbuddy.com>",
         :subject => @subject)
  end
end

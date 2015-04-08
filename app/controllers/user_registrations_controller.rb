class UserRegistrationsController < Devise::RegistrationsController
  def new
    super
  end
  
  def create
    super
    if (cookies[:referral_code])
      referrer_user = User.find_by_referral_code(cookies[:referral_code])
      if (referrer_user)
        Referral.create(:referrer_id => referrer_user.id, :referee_id => @user.id)
      end
      cookies.delete(:referral_code)
    end
    
    if (cookies[:promo] && Promo.exists?(cookies[:promo]))
      promo = Promo.find(cookies[:promo])
      cookies.delete(:promo)
      if (promo.every)
        if (promo.redeemed_offers.to_i % promo.every == 0 && (!promo.max_offers || promo.redeemed_offers < promo.max_offers) && promo.active)
          promo.redeemed_offers = promo.redeemed_offers.to_i + 1
          promo.save
          @user.balance = promo.credit
          @user.promo_id = promo.id
          @user.save
          flash[:notice] = "Welcome to UsherBuddy!  As one of every #{promo.every.ordinalize} user to sign up through the #{promo.display_name} promo, your UsherBuddy account has been credited #{promo.display_credit}! Congratulations!"
        elsif (!promo.active || (promo.max_offers && promo.redeemed_offers >= promo.max_offers))
          @user.balance = 0
          @user.promo_id = promo.id
          @user.save
          flash[:notice] = "Welcome to UsherBuddy!  Unfortunately, the #{promo.display_name} promo is no longer available, and you are therefore ineligable for complementary UsherBuddy credit.  However, we hope you enjoy all that UsherBuddy has to offer, even on your own dime!"
        else
          promo.redeemed_offers = promo.redeemed_offers.to_i + 1
          promo.save
          @user.balance = 0
          @user.promo_id = promo.id
          @user.save
          flash[:notice] = "Welcome to UsherBuddy!  Unfortunately, you were not one of every #{promo.every.ordinalize} user to sign up through the #{promo.display_name} promo, and are therefore ineligable for complementary UsherBuddy credit.  However, we hope you enjoy all that UsherBuddy has to offer, even on your own dime!"
        end
      else
        if (promo.redeemed_offers.to_i < promo.max_offers && promo.active)
          promo.redeemed_offers = promo.redeemed_offers.to_i + 1
          promo.save
          @user.balance = promo.credit
          @user.promo_id = promo.id
          @user.save
          flash[:notice] = "Welcome to UsherBuddy!  As one of the first #{promo.max_offers} users to sign up through the #{promo.display_name} promo, your UsherBuddy account has been credited #{promo.display_credit}!"
        else
          @user.balance = 0
          @user.promo_id = promo.id
          @user.save
          if (promo.active)
            flash[:notice] = "Welcome to UsherBuddy!  You were not one of the first #{promo.max_offers} users to register for the #{promo.display_name} promo, and are therefore ineligable for complementary UsherBuddy credit.  However, we hope you enjoy all that UsherBuddy has to offer, even on your own dime!"
          else
            flash[:notice] = "Welcome to UsherBuddy!  The #{promo.display_name} promo has been discontinued, and we are therefore unable to offer you complementary UsherBuddy credit.  However, we hope you enjoy all that UsherBuddy has to offer, even on your own dime!"
          end
        end
      end
    else
      @user.balance = 0
      @user.save
      flash[:notice] = "Your new account has been created successfully.  Welcome to UsherBuddy!"
    end
  end
  
  def update
    super
  end
end

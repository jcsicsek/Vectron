class AddReferralCodes
  def self.add_codes
    User.all.each do |user|
      user.referral_code = rand(36**8).to_s(36)
      user.save(false)
    end
  end
end

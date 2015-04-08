# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110926011638) do

  create_table "admins", :force => true do |t|
    t.string   "email",                              :default => "", :null => false
    t.string   "encrypted_password",  :limit => 128, :default => "", :null => false
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "amenities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bank_account_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_amenities", :force => true do |t|
    t.integer  "business_id"
    t.integer  "amenity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_event_types", :force => true do |t|
    t.integer  "business_id"
    t.integer  "event_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "businesses", :force => true do |t|
    t.string   "email",                                     :default => "", :null => false
    t.string   "encrypted_password",         :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                             :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "street_address"
    t.string   "city_address"
    t.integer  "city_id"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "neighborhood"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street_address_2"
    t.string   "website_url"
    t.integer  "payment_type_id"
    t.integer  "default_payment_type_id"
    t.integer  "default_payment_profile_id"
    t.string   "twitter_handle"
    t.string   "facebook_url"
    t.text     "description"
    t.boolean  "active"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "photo_remote_url"
    t.integer  "ticket_cutoff"
  end

  add_index "businesses", ["email"], :name => "index_businesses_on_email", :unique => true
  add_index "businesses", ["reset_password_token"], :name => "index_businesses_on_reset_password_token", :unique => true

  create_table "children", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_card_types", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "direct_deposit_profiles", :force => true do |t|
    t.string   "bank_name"
    t.integer  "bank_account_type_id"
    t.string   "account_number"
    t.string   "routing_number"
    t.integer  "business_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "educations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_schedules", :force => true do |t|
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "saturday"
    t.boolean  "sunday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_templates", :force => true do |t|
    t.integer  "business_id"
    t.integer  "event_type_id"
    t.string   "name"
    t.datetime "event_time"
    t.integer  "full_value_cents"
    t.boolean  "active"
    t.text     "description"
    t.text     "details"
    t.text     "terms"
    t.integer  "external_id"
    t.string   "genre"
    t.string   "photo_remote_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "from_date"
    t.datetime "to_date"
    t.integer  "venue_id"
    t.integer  "ticket_cutoff"
  end

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genders", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", :force => true do |t|
    t.integer  "event_type_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "houses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incomes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "user_id"
    t.integer  "voucher_id"
    t.integer  "transaction_id"
    t.integer  "amount"
    t.integer  "number"
    t.boolean  "settled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paper_check_profiles", :force => true do |t|
    t.string   "street_address"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone_number"
    t.integer  "business_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_profiles", :force => true do |t|
    t.string   "payment_cim_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paypal_profiles", :force => true do |t|
    t.string   "paypal_username"
    t.integer  "business_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promos", :force => true do |t|
    t.string   "name"
    t.integer  "max_offers"
    t.integer  "redeemed_offers"
    t.integer  "credit"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "every"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

  create_table "referrals", :force => true do |t|
    t.integer  "referrer_id"
    t.integer  "referee_id"
    t.integer  "voucher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscriber_referrer_id"
  end

  create_table "relationship_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriber_event_types", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "event_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", :force => true do |t|
    t.string   "email"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "promo_id"
    t.string   "referral_code"
    t.integer  "balance"
    t.integer  "email_schedule_id"
    t.boolean  "preferences_set"
    t.string   "zip_code"
  end

  create_table "thumbs", :force => true do |t|
    t.boolean  "up"
    t.boolean  "down"
    t.integer  "user_id"
    t.integer  "voucher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "invoice_id"
    t.string   "confirmation_id"
    t.boolean  "error"
    t.string   "error_code"
    t.string   "error_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_event_types", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_type_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                     :default => "", :null => false
    t.string   "encrypted_password",         :limit => 128, :default => "", :null => false
    t.string   "password_salt",                             :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                             :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "city_id"
    t.integer  "gender_id"
    t.integer  "education_id"
    t.integer  "employment_id"
    t.integer  "income_id"
    t.integer  "house_id"
    t.integer  "relationship_status_id"
    t.integer  "children_id"
    t.string   "customer_cim_id"
    t.integer  "default_payment_profile_id"
    t.string   "zip_code"
    t.date     "birthday"
    t.string   "authentication_token"
    t.integer  "balance"
    t.integer  "promo_id"
    t.string   "referral_code"
    t.integer  "subscriber_id"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.string   "street_address"
    t.string   "street_address_2"
    t.string   "city_address"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone_number"
    t.string   "neighborhood"
    t.integer  "business_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  create_table "voucher_offers", :force => true do |t|
    t.integer  "voucher_id"
    t.boolean  "accepted"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "quantity"
    t.integer  "payment_profile_id"
    t.integer  "voucher_price_cents"
    t.integer  "amount_from_payment"
    t.integer  "amount_from_balance"
  end

  create_table "vouchers", :force => true do |t|
    t.integer  "business_id"
    t.integer  "event_type_id"
    t.string   "name"
    t.datetime "event_time"
    t.integer  "offer_lifespan_minutes"
    t.integer  "max_offers"
    t.integer  "voucher_price_cents"
    t.integer  "full_value_cents"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.text     "details"
    t.text     "terms"
    t.integer  "external_id"
    t.string   "genre"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "purchase_count"
    t.string   "photo_remote_url"
    t.boolean  "launched"
    t.float    "commission"
    t.integer  "event_template_id"
    t.integer  "venue_id"
    t.integer  "ticket_cutoff"
  end

end

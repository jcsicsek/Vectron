class SubscriberEventType < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :event_type
end

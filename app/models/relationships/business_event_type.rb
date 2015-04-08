class BusinessEventType < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :business
end

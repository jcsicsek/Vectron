class EmailSchedule < ActiveRecord::Base
  has_one :subscriber
end

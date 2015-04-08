class Subscriber < ActiveRecord::Base
  validates_presence_of :email
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
  validates_uniqueness_of :email
  
  belongs_to :city
  belongs_to :promo
  belongs_to :email_schedule
  
  has_many :event_types, :through => :subscriber_event_types
  has_one :user
  
  after_create :initialize_subscriber
  
  def initialize_subscriber
    EventType.all.each do |event_type|
      SubscriberEventType.create(:event_type_id => event_type.id, :subscriber_id => self.id)
    end
    es = EmailSchedule.create(
      :monday => true,
      :tuesday => true,
      :wednesday => true,
      :thursday => true,
      :friday => true,
      :saturday => true,
      :sunday => true
    )
    es.save
    self.email_schedule_id = es.id
    self.preferences_set = false
    self.save(false)
  end
end

class Event < ApplicationRecord
    enum time: [:past, :future]

    has_many :event_users
    has_many :users, :through => :event_users
end

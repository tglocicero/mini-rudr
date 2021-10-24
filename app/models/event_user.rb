class EventUser < ApplicationRecord
    enum response: [:ignored, :accepted, :declined]

    belongs_to :user
    belongs_to :event
end

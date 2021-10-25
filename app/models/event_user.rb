class EventUser < ApplicationRecord
    enum response: [:ignored, :accepted, :declined]

    belongs_to :user
    belongs_to :event

    after_create -> { self.user.increment!(:score) }
end

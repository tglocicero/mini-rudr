class UpdateUserScoresJob < ActiveJob::Base
    queue_as :default

    def perform(event)
        event.users.each do |user|
            user.adjust_score(event.id)
        end
    end
end
class UpdateUserScoresJob < ActiveJob::Base
    queue_as :default

    def perform(event)
        event.users.each do |user|
            user.calculate_score
        end
    end
end
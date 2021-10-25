class User < ApplicationRecord
    has_many :event_users
    has_many :events, :through => :event_users

    # This was my first approach. Leaving it here so we can discuss
    # def set_score
    #     invitations = self.event_users
    #     accepted_invitations = invitations.accepted.count
    #     declined_invitations = invitations.declined.count
    #     ignored_invitations = invitations.ignored.count
    #     non_declined_invitation_absences = self.event_users.not_declined.where(present: false, id: self.events.past).count
    #     self.score = invitations.count + accepted_invitations - declined_invitations - (2 * ignored_invitations) - (3 * non_declined_invitation_absences)
    #     self.save
    # end

    def adjust_score(event_id)
        event_user = EventUser.where(user_id: self.id, event_id: event_id).first
        adjustment = 0
        case event_user.response
        when "accepted"
            adjustment += 1
        when "declined"
            adjustment -= 1
        when "ignored"
            adjustment -= 2
        end
        adjustment -= 3 if event_user.response != "declined" && !event_user.present
        self.increment!(:score, adjustment)
    end
end

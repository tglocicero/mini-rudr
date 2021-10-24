class User < ApplicationRecord
    has_many :event_users
    has_many :events, :through => :event_users

    def calculate_score
        invitations = self.event_users
        accepted_invitations = invitations.accepted.count
        declined_invitations = invitations.declined.count
        ignored_invitations = invitations.ignored.count
        non_declined_invitation_absences = invitations.not_declined.where("present = ?", false).count
        self.score = invitations.count + accepted_invitations - declined_invitations - (2 * ignored_invitations) - (3 * non_declined_invitation_absences)
        self.save
    end
end

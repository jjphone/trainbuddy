module InvitationsHelper
  def invitation_message(invit_id)
  	invit = Invitation.find_by_id(invit_id)
  	res = "Hi, \n\n#{invit.sender.name} has asked you to join Trainbuddy. Please go to the link below to signup for your account.\n\n"
  	return [res, invitations_url.to_s, "/", invit.token.to_s].join
  end

end

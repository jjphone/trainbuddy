module RelationshipsHelper
  
  def sample_request_msg(user)
    return "" if current_user.nil? or user.nil?
    res = "Hi #{user.name},\n\n#{current_user.name} would like to connect and be-friend with you; to share updates and whereabouts together. \n\nPlease confirm your relations by visiting the links provided.\n\n\n"
  end
  
end

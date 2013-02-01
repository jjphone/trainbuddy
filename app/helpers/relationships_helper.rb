module RelationshipsHelper
  
  def sample_request_msg(user)
    return "" if current_user.nil? or user.nil?
    res = "Hi #{user.name},\n\n#{current_user.name} would like to connect and be-friend with you; to share updates and whereabouts together. \n\nPlease confirm your relations by visiting the links provided.\n\n\n"
  end
  

  def friend_request_mail(from, to, mail_body)
  	option_link = ['<b>Link to : </b><a href="', root_url, from.to_permalink, '">', from.name, "\'s Profile and Friend Request</a>"].join
  	m = Mail.new(owner: from, sender: from, sent_date: Time.now, status: 0,
  					subj: "Relationship Request by #{from.name}", body: mail_body, to_users: "#{to.id}=#{to.name};" )
  	m.save
  	Mail.send_mail(m, to) unless from.block_by?(to)
  	flash[:Success] = "Friend Request sent to #{to.name}"
  end

end

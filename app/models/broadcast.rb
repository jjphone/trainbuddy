class Broadcast < ActiveRecord::Base
  attr_accessible :bc_content, :ref_msg, :source, :status, :user_id

  belongs_to 		:msg,	class_name: "Message", 	foreign_key: "ref_msg"

  default_scope order: 'broadcasts.created_at DESC'
  
  # def self.cipher_msg(data, expired)
  # 	message = data.split(/#|;/)
  # 	# list_tag = today? "<li class=\"cast-today\">" : "<li>Expired : "
  # 	res = ""
  # 	header = message.delete_at(0)


  # 	if  !message.empty?
  # 	  message.map!{ |m|
  # 	  	parts = m.split(/@/)
  # 	  	case parts[1][0]
  # 	  	when "+"
		#   res = parts[1][1].to_i > 1 ? "#{parts[1][1]} trains behind of you." : "1 train behind of you."
  #   	when "-"
  #     	  res = parts[1][1].to_i > 1 ? "#{parts[1][1]} trains ahead of you." : "1 train ahead of you."
  #   	else
		#   res = "on the same train with you."
		# end
		# if today
		#   m = parts[0] + " going to " + parts[1][3...-1] + ", is " + res
		# else
		#   m = parts[0] + " went to " + parts[1][3...-1] + ", was " + res
		# end
  # 	  }
  # 	  res = "<ul><li>" + message.join("</li><li>") + "</li></ul>"
  # 	end
  # 	if expired?
  # 	  return "<li class=\"cast-now\">" + header + res + "</li>"
  # 	else
  # 	  return "<li>Expired : " + header + res + "</li>"
  # 	end

  # end




end

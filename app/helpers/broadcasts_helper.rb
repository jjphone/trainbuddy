module BroadcastsHelper

  def show_broadcast
  	if current_user
      bc = current_user.broadcasts.where("status < 10")
      #Rails.logger.debug("BroadcastsHelper:: show_broadcast : bc =  " + bc.inspect )
      if bc.size > 0
        msg = "<ul id=\"cast-list\">"
        bc.each{ |b| msg += cipher_content(b.bc_content, b.updated_at.today?) }
        bc.transaction do
          bc.lock
          bc.update_all("status = 28")
        end
        flash.now[:Broadcasts] = msg+ "</ul>"
      end
  	end
  end


  def cipher_content(data, today)
    #Rails.logger.debug(" ---- cipher_content(#{data})")
    message = data.split(/@/)
    header = message.delete_at(0)
    res = ""
    if !message.empty?
      message.map!{ |u|
        parts = u.split(/#/)
        case parts[1][0]
        when "+"
          temp = parts[1][1].to_i > 1 ? "#{parts[1][1]} trains behind of you." : "1 train behind of you."
        when "-"
          temp = parts[1][1].to_i > 1 ? "#{parts[1][1]} trains ahead of you." : "1 train ahead of you."
        else
          temp = "on the same train with you."
        end
        if today
          u = parts[0]+ " going to " +parts[1][3..-1]+ ", and is " +temp
        else
          u = parts[0]+ " went to " +parts[1][3..-1]+ ", and was " +temp
        end
      }
      res = "<ul><li>" +message.join("</li><li>")+ "</li></ul>"
    end

    if today
      return "<li class=\"cast-now\"><h6>" +header+"</h6>" +res+ "</li>"
    else
      return "<li><h6>Expired : " +header+ "</h6>" +res+ "</li>"
    end

  end

end

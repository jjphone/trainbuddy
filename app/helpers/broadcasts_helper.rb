module BroadcastsHelper

  def show_broadcast
  	if current_user
  	  Rails.logger.debug("BroadcastsHelper:: show_broadcast")
      bc = current_user.broadcasts.where("status < 10")
      if bc.size > 0
        msg = "<ul id=\"broadcast\">"
        bc.each { |b| msg += translate_content(b.bc_content, b.updated_at.today?) }
        bc.transaction do
          bc.lock
          bc.update_all("status = 28")
        end
        flash.now[:Info] = msg + "</ul>"
      end
  	end
  end

  def translate_content(data, today)
    parts = data.split("@")
    case parts[1][0]
    when "+"
      res =  parts[1][1].to_i > 1 ? "#{parts[1][1]} trains behind of you.</li>" : "#{parts[1][1]} train behind of you.</li>"
    when "-"
      res = parts[1][1].to_i > 1 ? "#{parts[1][1]} trains ahead of you.</li>" : "#{parts[1][1]} train ahead of you.</li>"
    else
      res = "on the same train with you.</li>"
    end
    if today
      res = "<li class=\"cast-today\">" + parts[0] + " travelling on " + parts[1][3...-1] + ", is " + res
    else
      res = "<li>Expired: " + parts[0] + " traveled on " + parts[1][3...-1] + ", was " + res
    end

  end

  
end

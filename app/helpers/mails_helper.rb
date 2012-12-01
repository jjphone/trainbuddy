module MailsHelper
  def status_icon(status)
    case status
    when 1
      return image_tag("/images/email_unread.png", :size=> "20x20", :alt =>"unread")
    when 2
      return image_tag("/images/email_read.png", :size=> "20x20", :alt =>"read")
    when 3
      return image_tag("/images/email_forward.png", :size=> "20x20", :alt =>"forward")
    when 4
      return image_tag("/images/email_replied.png", :size=> "20x20", :alt =>"replied")
    else
      return image_tag("/images/email_sent.png", :size=> "20x20", :alt =>"sent")
    end
  end




end

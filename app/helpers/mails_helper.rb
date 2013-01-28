module MailsHelper
  def status_icon(status)
    case status
    when 1
      return image_tag("/images/email_unread.png", :size=> "25x25", :alt =>"unread", :title =>"unread")
    when 2
      return image_tag("/images/email_read.png", :size=> "25x25", :alt =>"read", :title =>"read")
    when 3
      return image_tag("/images/email_forward.png", :size=> "25x25", :alt =>"forward", :title =>"forward")
    when 4
      return image_tag("/images/email_replied.png", :size=> "25x25", :alt =>"replied", :title =>"replied")
    else
      return image_tag("/images/email_sent.png", :size=> "25x25", :alt =>"sent", :title =>"sent")
    end
  end




end

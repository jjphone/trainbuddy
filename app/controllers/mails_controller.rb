class MailsController < ApplicationController
  before_filter :signed_in_user
  before_filter :allowed_read, only: [:index, :show]
  before_filter :allowed_write, only: [:update, :destroy, :new, :create]

  before_filter :show_broadcast
  
  def index 
    case params[:folder]
    when "unread"
      @title = "Message - Unread"
      @mails = current_user.unread_mails.paginate(page: params[:page], per_page: 10)
    when "sent"
      @title = "Message - Sent"
      @mails = current_user.sent_mails.paginate(page: params[:page], per_page: 10)
    when "all"
      @title = "Message - All"
      @mails = current_user.mails.paginate(page: params[:page], per_page: 10)
    else
      @title = "Message - Inbox"
      @mails = current_user.incoming_mails.paginate(page: params[:page], per_page: 10)
    end
  end

  def show
	  @mail = current_user.mails.find_by_id(params[:id].to_i)
    if @mail.nil? 
      mail_error(nil, " - show mail with id: " + params[:id].to_s)
      redirect_to mails_path
    else
      Mail.update(@mail, {:status => 2}) if @mail.status ==1
    end
  end


 def update
    case params[:commit]
    when "Delete marked"
      msg = " mail(s) deleted"
      res = Mail.delete_all(["owner =  #{current_user.id} and id in ( ? )", params[:mail_ids] ])
    when "Mark as unread"
      msg = " mail(s) marked as unread"
      res = Mail.update_all("status = 1", ["owner =  #{current_user.id} and status <> 0 and id in ( ? )", params[:mail_ids]])
    else
      msg = " mail(s) marked as read"
      res = Mail.update_all("status = 2", ["owner =  #{current_user.id} and status <> 0 and id in ( ? )", params[:mail_ids]])
    end
    flash[:Success] = "Done :" + res.to_s + msg
    redirect_to mails_path
  end

  def destroy
    if params[:mail_ids]
      res = Mails.delet_all(["owner = ? AND id in ( ? ) ", current_user.id, params[:mail_ids]])
    else
      current_user.mails.find(params[:id]).destroy
      res = 1
    end
    flash[:Success] = "Done : #{res.to_s} message(s) deleted."
    redirect_to mails_path
  end



  def new
    @mail = Mail.new(body: "", subj: "" )
    case params[:op].to_i
    when 3
      @title = "Message - Forward"
      source = current_user.mails.find_by_id(params[:id].to_i)
      if source
		  @mail.subj = "Fw: " + source.subj
		  @mail.body = "\n> " + source.body.gsub(/\n/, "\n> ")
      end
    when 4
      @title = "Message - Reply"
      source = current_user.mails.find_by_id(params[:id].to_i)
      if source
		    @mail.subj = "Rw: " + source.subj
		    @mail.body = "\n> " + source.body.gsub(/\n/, "\n> ")
        @mail.to_users = "#{source.sender.id} = #{source.sender.name};"
		  end
    else
      # compose new
      @title = "Message - Compose"
      @mail.subj = ""
      @mail.body = ""
    end
    @user = User.find_by_id(params[:to]) if params[:to] 
    #@user used for replay back sender
    @mail.to_users = "#{@user.id} = #{@user.name};" if @user
  end

  def create 
    # NOT @mail =  Mails.new(params[:mail]), as many customized fields
    @mail = Mail.new
    @mail.subj = params[:mail][:subj].length == 0 ? "< Blank Subject >" : CGI.escapeHTML(CGI.unescape(params[:mail][:subj]))
    @mail.body = params[:mail][:body].length == 0 ? "< Blank Mail Body >" : CGI.escapeHTML(CGI.unescape(params[:mail][:body]))
    @mail.sender = current_user
    @mail.owner = current_user
    @mail.status = 0
    @mail.sent_date = Time.now
    
    user_ids = params[:mail][:to_users].split(";").collect(&:to_i)
    send_users = User.where("id in (?) and id not in (select f.user_id from relationships f where f.status = -1 and f.friend_id = ? and f.user_id in (?) )",
                            user_ids, current_user.id, user_ids)
    @mail.to_users = send_users.collect { |n| "#{n.id}=#{n.name};"}.join

    if @mail.save
      Mail.send_mail( @mail, send_users )
    else
      mail_error(nil, " - Sending new mail.")
    end
    redirect_to mails_path

  end


private
  def mail_error(mail, msg)
    flash[:Error] = "Issue with previous operation, check and try again later." + msg
    mail.destroy unless mail.nil?
  end
  
  def allowed_read
    if current_user.profile.settings.message < 1
      flash[:Error] = "Insufficient privilege on accessing mails"
      redirect_to root_path
    end
  end

  def allowed_write
    if current_user.profile.settings.message < 2
      flash[:Error] = "Insufficient privilege on create or modifying mails"
      redirect_to root_path
    end     
  end


end

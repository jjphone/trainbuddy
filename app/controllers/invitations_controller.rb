class InvitationsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :edit]
  before_filter :new_user_only, only: [:show, :update]

  def new
  	if current_user.profile.invitations < 1
  	  flash[:Error] = "Insufficient invitations left. Increase your current level to gain more invitations."
  	  redirect_to edit_profile_path(current_user.id)
  	else
 	  @invitation = current_user.sent_invitations.build
  	end
  end

  def create
  	@invitation = current_user.sent_invitations.build(recipient_email: params[:email])
  	@invitation.multiple = params[:multiple] if current_user.admin?
  	if @invitation.save
  	  flash[:Success] = "invitation created."
  	  redirect_to edit_invitation_path(@invitation)
  	else
  	  flash.now[:Error] = list_errors @invitation
  	  render 'new'
  	end
  end

  def edit
  	@invitation = current_user.sent_invitations.find_by_id(params[:id])
  	unless @invitation
  	  flash[:Error] = "Invitation( #{params[:id]} ) could not be found, please create new one again."
  	  redirect_to edit_profile_path(current_user.id)
  	end
  end

  def show
  	# signup
  	@invitation = Invitation.find_by_token(params[:id])
  	if @invitation
  	  if @invitation.multiple > 0
  	  	@user = User.new
  	  	@user.email = @invitation.recipient_email if @invitation.recipient_email.size > 0
  	  else
  	  	flash[:Error] = "Invitation has expired."
  	  	redirect_to root_path
  	  end
  	else
  	  flash[:Error] = "Invitation( #{params[:id]} ) is NOT found."
  	  redirect_to root_path
  	end
  end

  def update
  	# create-user
  	invit = Invitation.find_by_token(params[:token_hash].to_s)
  	if invit && invit.multiple > 0
  	  @user = User.new(params[:user])
  	  @user.email = invit.recipient_email if invit.recipient_email.size>0
  	  if @user.save
  	  	@user.profile.update_attributes(invitation_id: invit.id)
  	  	invit.decrement! :multiple
  	  	
  	  	Relationship.request @user.id, invit.sender.id
        friend_request_mail(@user, invit.sender, sample_request_msg(@user))
  	  	sign_in @user
  	  	flash[:Success] = "User created..."
  	  	redirect_to root_path
  	  else
  	  	flash.now[:Error] = list_errors @user
  	  	render 'show'
  	  end

  	else
  	  flash[:Error] = "Invitation is not valid or expired, please request for new one."
  	  redirect_to root_path
  	end


  end

private
  def new_user_only
  	if signed_in?
  	  flash[:Error] = "You are currently a registed user, please logout first before create a new account."
  	  redirect_to root_path
  	end
  end

end

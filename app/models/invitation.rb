# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  sender_id       :integer
#  recipient_email :string(255)
#  token           :string(255)      not null
#  sent_at         :datetime
#  multiple        :integer          default(1)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Invitation < ActiveRecord::Base
  attr_accessible :recipient_email, :sender_id, :sent_at, :token, :multiple
  
  belongs_to :sender, class_name: "User", include: :profile

  validates_presence_of :sender_id
  validate :recipient_is_not_registered
  validate :sender_has_invitations, :if => :sender

  before_create :generate_token
  before_create :decrement_counts
  


  def recipient_is_not_registered
  	self.errors.add :recipient_email, 'is already registered' if User.find_by_email(recipient_email)
  end

  def sender_has_invitations
  	unless sender.profile.invitations > 0
  	  errors.add :base, 'Excessed max limit invitations for the user'
  	end
  end

  def generate_token
  	self.token = Digest::SHA1.hexdigest([sender.login, Time.now, rand].join)
  end

  def decrement_counts
  	sender.decrement_invit
  end

  def redempt_invit
    self.decrement! :multiple
  end


end

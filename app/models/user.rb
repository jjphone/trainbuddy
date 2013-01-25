# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  login               :string(255)
#  email               :string(255)
#  phone               :string(255)
#  level               :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  password_digest     :string(255)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  remember_token      :string(255)
#

class User < ActiveRecord::Base
  attr_accessible 	:email, :name, :login, :phone, :avatar, :login,
  					:password_digest, :password, :password_confirmation
  has_secure_password
  has_many :microposts,         dependent: :destroy
  has_many :relationships,      dependent: :destroy
  has_many :broadcasts,         dependent: :destroy

  has_many :plans,              dependent: :destroy
  has_one  :profile,            dependent: :destroy

  
  has_many :reverse_relationships, foreign_key: "friend_id", class_name: "Relationship", 
                                dependent: :destroy
  
  has_many :friends,      through: :relationships,         source: :friend, conditions: "status= 3"
  # has_many :friended_by,  through: :reverse_relationships, source: :user,   conditions: "status= 3"
  # has_many :blocked_by,   through: :reverse_relationships, source: :user,   conditions: "status= -1"
  # relationship.status = -1  -> blocked

  has_many :mails,          foreign_key: "owner", class_name: "Mail", dependent: :"destroy"
  has_many :sent_mails,     foreign_key: "owner", class_name: "Mail", dependent: :"destroy", conditions: "status = 0"
  has_many :unread_mails,   foreign_key: "owner", class_name: "Mail", dependent: :"destroy", conditions: "status = 1"
  has_many :incoming_mails, foreign_key: "owner", class_name: "Mail", dependent: :"destroy", conditions: "status <> 0"


  before_save 		{ self.email.downcase! 
                    self.name.capitalize!
                    self.login.downcase!
                  }
  before_save     :create_remember_token
  after_create    :create_profile
  

  validates :name,  			presence:   	true,
  								length:     	{ maximum:  50 }

  validates :password, 			presence: 		true, 
  								length: 		{ minimum: 6 }
  validates :password_confirmation, presence: 	true

  email_regex =   /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  phone_regex =   /[+|-|*]*\d+/i
  login_regex =   /[a-z][a-z0-9]*(_|.){1}[a-z0-9]+/i

  validates :email,     		presence:   	true,
                        		format:     	{ with: email_regex },
                        		uniqueness: 	{ case_sensitive: false }
  validates :login,         uniqueness:   { case_sensitive: false }
  validates :phone,         uniqueness:   { case_sensitive: false }

  has_attached_file :avatar, 	  style:  { large: "100x100", thumb: "30x30", small: "60x60", },
                                url:    "/trainbuddy/icons/:id/:basename.:extension",
                                path:   ":rails_root/public/icons/:id/:basename.:extension",
                                default_url: "/trainbuddy/icons/noavatar_middle.gif"


  def to_permalink
    if login
      "u/#{login}"
    else
      "users/#{id}"
    end
  end


  def admin?
    return profile.settings.admin > 0
  end

  def level
    return profile.settings.level
  end


  def suggest_friends
  end

  def common_friends(other)
  end

  def has_access?(other_id)
    return ((other_id == self.id) || friended_by?(other_id))
  end

  def friended_by?(other_id)
    return Relationship.status(other_id, self.id) == 3
  end

  def block_by?(other_id)
    return Relationship.status(other_id, self.id) == -1
  end

  # def ext_setting
  #   self.profile.nil? ? Profile.create(user_id: self.id) : self.profile
  # end



private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def create_profile
    Profile.create(user_id: self.id)
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  login      :string(255)
#  email      :string(255)
#  phone      :string(255)
#  level      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible 	:email, :name, :login, :phone, :avatar,
  					:password_digest, :password, :password_confirmation
  has_secure_password


  


#  before_save 		{ |user| user.email = email.downcase }
 	# alternate before_save coding
  before_save 		{ self.email.downcase! }
  before_save     :create_remember_token
  

  validates :name,  			presence:   	true,
  								length:     	{ maximum:  50 }
  validates :password, 			presence: 		true, 
  								length: 		{ minimum: 6 }
  validates :password_confirmation, presence: 	true

  email_regex =   /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,     		presence:   	true,
                        		format:     	{ with: email_regex },
                        		uniqueness: 	{ case_sensitive: false }

  has_attached_file :avatar, 	  style:  { large: "200x200", thumb: "30x30", small: "60x60", },
                                url:    "/trainbuddy/icons/:id/:basename.:extension",
                                path:   ":rails_root/public/icons/:id/:basename.:extension",
                                default_url: "/trainbuddy/icons/noavatar_middle.gif"


private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end  
end

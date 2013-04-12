# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :string(255)
#  opt_link   :string(255)
#  message_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  expire_at  :datetime
#  s_time     :datetime
#  e_time     :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content, :s_time, :e_time, :user_id
  
  belongs_to :user

  validates 	:user_id, 		presence: true
  validates		:content, 		presence: true, 	length: { maximum: 140 } 
  default_scope order: 			'microposts.updated_at DESC'
  self.per_page = 10


end

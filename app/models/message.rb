# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :integer
#  parent_id  :integer
#  content    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ActiveRecord::Base
  attr_accessible :content, :parent_id, :status, :user_id

  has_many 		:childs, 	class_name: "Message",		foreign_key: "parent_id"
  belongs_to	:parent,	class_name: "Message",		foreign_key: "parent_id"
  

  
end

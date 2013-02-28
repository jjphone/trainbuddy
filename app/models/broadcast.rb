# == Schema Information
#
# Table name: broadcasts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :integer
#  source     :integer
#  ref_msg    :integer
#  bc_content :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Broadcast < ActiveRecord::Base
  attr_accessible :bc_content, :ref_msg, :source, :status, :user_id

  belongs_to 		:msg,	class_name: "Message", 	foreign_key: "ref_msg"

  default_scope order: 'broadcasts.created_at DESC'
  



end

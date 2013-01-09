class Broadcast < ActiveRecord::Base
  attr_accessible :bc_content, :ref_msg, :source, :status, :user_id

  belongs_to 		:msg,	class_name: "Message", 	foreign_key: "ref_msg"

  default_scope order: 'broadcasts.created_at DESC'
  



end

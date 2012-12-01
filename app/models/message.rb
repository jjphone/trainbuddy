class Message < ActiveRecord::Base
  attr_accessible :content, :parent_id, :status, :user_id

  has_many 		:childs, 	class_name: "Message",		foreign_key: "parent_id"
  belongs_to	:parent,	class_name: "Message",		foreign_key: "parent_id"
  

  
end

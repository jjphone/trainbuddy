# == Schema Information
#
# Table name: mails
#
#  id         :integer          not null, primary key
#  owner      :integer
#  sender     :integer
#  subj       :string(255)
#  body       :string(255)
#  option     :string(255)
#  status     :integer
#  parent_id  :integer
#  to_users   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sent_date  :datetime
#

class Mail < ActiveRecord::Base
  attr_accessible :owner, :sender,  :status, :subj, :body, :option, :to_users, :parent_id, :sent_date
 
  belongs_to 	:owner, 	class_name: "User", foreign_key: "owner"
  belongs_to 	:sender, 	class_name: "User", foreign_key: "sender"
  has_many 		:childs, 	class_name: "Mail", foreign_key: "parent_id"
  belongs_to 	:parent,	class_name: "Mail", foreign_key: "parent_id"
  has_many 		:receipients, through:  :childs, :source => :owner, :uniq => true


  validates	:owner,	 	presence: true
  validates	:sender,	presence: true
 
  default_scope order: 'mails.created_at DESC'

  SENT = 0
  UNREAD = 1
  READ = 2
  FORWARD = 3
  REPLIED = 4


  def self.send_mail(mail, receipients)
    receipients = Array(receipients)
    receipients.each { |x| create!(owner: x, sender: mail.sender, status: UNREAD, sent_date: mail.sent_date, 
                                   subj: mail.subj, body: mail.body, option: mail.option, parent_id: mail.id,
                                   to_users: mail.to_users) }
  end

  def self.update_status(owner, id, status)
    m = find_by_id_and_owner(id, owner)
    return false unless m
    m.status = status
    m.save!
  end

  def to_users_json
    return nil if self.to_users.nil?
    res = self.to_users.split(";").collect do |n|
      { :id => n.to_i, :name => n[/=.+/][1...n.size] }
    end
  
  end

  def status_to_s
  	case self.status
  	when SENT
  		return "Sent"
  	when UNREAD
  		return "Unread"
  	when READ
  		return "Read"
  	when FORWARD
  		return "Forward"
  	when REPLIED
  		return "Replied"
  	end
  end

end

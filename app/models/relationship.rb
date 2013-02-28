# == Schema Information
#
# Table name: relationships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  status     :integer
#  alias_name :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Relationship < ActiveRecord::Base
  attr_accessible :status, :user_id, :friend_id, :alias_name
  belongs_to	:user,		class_name: "User"
  belongs_to	:friend, 	class_name: "User", foreign_key: "friend_id"

  validates :user_id, 		presence: true
  validates :friend_id, 	presence: true
  validates :status,		presence: true

  ALIAS = 5
  OWN = 4
  FRIEND = 3
  PENDING = 2
  REQUEST = 1
  STRANGER = 0
  BLOCKED = -1

  def status_to_s
    case status
    when -1
      return "Blocked"
    when 1
      return "Request"
    when 2
      return "Pending"
    else
      return "Friended"
    end
  end



  def self.status(owner_id, other_id)
  	return OWN if owner_id == other_id
  	return STRANGER unless res = find_relation(owner_id, other_id)
  	return res.status
  end

  def self.status_str(owner_id, other_id)
    case status(owner_id, other_id)
    when -1
      return "Blocked"
    when 0
      return "Stranger"
    when 1
      return "Requested"
    when 2
      return "Pending Acceptance"
    when 3
      return "Friended"
    when 4
      return "Own"
    end
  end

  def self.set_alias(user_id, other_id, nick)
    user_rel = lock.find_by_user_id_and_friend_id(user_id, other_id)
    if user_rel
      user_rel.alias_name = nick
      return user_rel.save
    else
      return false
    end
  end


  def self.request(user_id, other_id, nick=nil)
  	return OWN if user_id == other_id
  	res = REQUEST

    transaction do 
		  if other_rel = lock.find_by_user_id_and_friend_id(other_id, user_id)
		    case other_rel.status
		    when FRIEND
          res = FRIEND
          update_one_side(FRIEND, user_id, other_id, nick)
		    when BLOCKED
          update_one_side( REQUEST, user_id, other_id, nick)
        when PENDING
          other_rel.updated_at = Time.now
          other_rel.save!
          update_one_side( REQUEST, user_id, other_id, nick)
        when REQUEST
          update_one_side( FRIEND, user_id, other_id,  nick)
          other_rel.status = FRIEND
          other_rel.save!
          res = FRIEND
        end
      else
        create(status: PENDING, user_id: other_id, friend_id: user_id, alias_name: nil )
		    self.update_one_side( REQUEST, user_id, other_id, nick)
		  end
    end
      return res
  end


  def self.accept(user_id, other_id, nick=nil)
  	return OWN if user_id == other_id
  	res = -1
  	transaction do
  		if other_rel = lock.find_by_user_id_and_friend_id(other_id, user_id)
  		  case other_rel.status
  		  when FRIEND
  			update_one_side(FRIEND, user_id, other_id, nick)
  			res = FRIEND
  		  when REQUEST
  			other_rel.status = FRIEND
  			other_rel.save!
  			update_one_side(FRIEND, user_id, other_id, nick)
  			res = FRIEND
  		  end
  		end
  	end
  	return res
  end


  def self.unfriend(user_id, other_id)
  	return OWN if user_id == other_id
  	res = STRANGER
  	transaction do
  		other_rel = lock.find_by_user_id_and_friend_id(other_id, user_id)
  		if other_rel && other_rel.status == BLOCKED
  			res = BLOCKED
  		else
  			other_rel.destroy
  		end
  		
  		if user_rel = lock.find_by_user_id_and_friend_id(user_id, other_id)
  			user_rel.destroy unless user_rel.status == BLOCKED
  		end
  	end
  	return res
  end


  def self.block(user_id, other_id)
  	return OWN if user_id == other_id
  	res = BLOCKED
  	transaction do 
  		if user_rel = lock.find_by_user_id_and_friend_id(user_id, other_id)
  			if user_rel.status == BLOCKED
  				user_rel.destroy
          other_rel = lock.find_by_user_id_and_friend_id(other_id, user_id)
          other_rel.destroy if other_rel && other_rel.status != BLOCKED
  				res = STRANGER
  			else
  				user_rel.status = BLOCKED
  				user_rel.save!
  			end
  		else
  			create!(status: BLOCKED, user_id: user_id, friend_id: other_id)
  		end
  	end
  	return res
  end

  def self.find_relation(owner_id, other_id)
	 find_by_user_id_and_friend_id(owner_id, other_id)
  end



private
	def self.update_one_side(status, user_id, other_id, nick)
		rel = lock.find_by_user_id_and_friend_id(user_id, other_id)
		if rel
			rel.status = status
			rel.alias_name = nick
			rel.save!
		else
			create!(status: status, user_id: user_id, friend_id: other_id, alias_name: nick)
		end
	end

end

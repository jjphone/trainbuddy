class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user


  validates 	:user_id, 		presence: true
  validates		:content, 		presence: true, 	length: { maximum: 140 } 
  default_scope order: 			'microposts.created_at DESC'

  def self.feed_source(user, src_type, post_type)
  	#select type [0, 1, 2]-> [ all, Friends Only (default), only self ]
  	case src_type.to_i
    when 0  # all postings
      conditions =%(SELECT friend_id FROM friendships WHERE user_id = :user_id and status = 3 union select :user_id )
    when 2  # only from user
      conditions = %(select :user_id)
    else    # Posts from user's Friends ONLY
      conditions = %(SELECT friend_id FROM friendships WHERE user_id = :user_id and status = 3)
    end
# post_type =>  0: all; 1: active; 2: expired
    Rails.logger.info("-----  Micropost.feed_source: conditions=> #{conditions}; ")
    where("user_id in (#{conditions})", {user_id: user.id} )
  end


end

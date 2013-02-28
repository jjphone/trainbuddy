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

  def self.select_feeds( user_id, other_id, posts)
    #select type [1, 2, 3]-> [ all (default), only self, Friends only ]
    posts = "11" if posts.nil?
    src_type = posts[0].to_i
    post_type = posts[1].to_i  
    case src_type
    when 1 #postings from friends + self
      condit = %{ SELECT friend_id FROM relationships 
                  WHERE status = 3 AND user_id = :user_id 
                  AND friend_id NOT IN (SELECT user_id FROM relationships WHERE status = -1 AND friend_id = :user_id) 
                  UNION SELECT :user_id }
    when 2 # display @user ONLY
      condit = %{ SELECT id from users 
                  WHERE id = :other_id
                  AND id NOT IN (SELECT user_id from relationships WHERE status = -1 AND friend_id = :user_id)}
    else  # friends from current_user
      condit = %{ SELECT friend_id from relationships 
                  WHERE status = 3 
                  AND user_id = :user_id
                  AND friend_id in 
                  ( SELECT user_id FROM relationships WHERE status = 3 AND friend_id = :user_id) }
    end

    case post_type
    when 0 # active + expired
#      Rails.logger.info("-----  Micropost.select_feeds: condit=> #{condit} ; user_id=#{user_id}, other_id=#{other_id}")
      res = where("user_id in (#{condit})", {user_id: user_id, other_id: other_id} )
    when 2 #only expired
#      Rails.logger.info("-----  Micropost.feed_source: condit=> #{condit}; user_id=#{user_id}, other_id=#{other_id}; limited to Expired")
      res = where("expire_at < '#{ Time.now }' AND user_id in (#{condit})", {user_id: user_id, other_id: other_id } )
    else # only Active
#      Rails.logger.info("-----  Micropost.feed_source: condit=> #{condit}; user_id=#{user_id}, other_id=#{other_id}; limited to Expired")
      res = where("user_id in (#{condit}) AND (expire_at is null OR expire_at > '#{Time.now}')", {user_id: user_id, other_id: other_id} )
    end
    res
  end

end

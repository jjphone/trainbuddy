# == Schema Information
#
# Table name: profiles
#
#  user_id       :integer          not null, primary key
#  search_mode   :integer          default(0), not null
#  level         :integer          default(2), not null
#  score         :integer          default(0), not null
#  notify_users  :integer          default(1), not null
#  invitations   :integer          default(10), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  invitation_id :integer
#

class Profile < ActiveRecord::Base
  attr_accessible :level, :score, :search_mode, :user_id, :invitation_id, :invitations
  belongs_to 	:settings, class_name: "LevelSetting", foreign_key: "level", primary_key: "level"
  belongs_to  :user


  self.primary_key = :user_id
  
  def inc_score()
   	return 0
  end

  def display_score
    return self.score.to_s + " / " + settings.max_score.to_s
  end


end

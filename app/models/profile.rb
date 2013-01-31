class Profile < ActiveRecord::Base
  attr_accessible :level, :score, :search_mode, :user_id
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

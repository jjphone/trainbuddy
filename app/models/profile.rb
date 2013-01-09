class Profile < ActiveRecord::Base
  attr_accessible :level, :score, :search_mode, :user_id
  belongs_to 	:settings, class_name: "LevelSetting", foreign_key: "level", primary_key: "level"
  belongs_to  :user

  set_primary_key :user_id

  def inc_score
   	s = settings
   	return self if s.step_value < 1
   	tmp = score + s.step_value
   	if tmp > s.max_score
   	  self.level += 1
   	  self.score = tmp - s.max_score
   	else
   	  self.score = tmp
   	end
   	self.save
   	return self
  end

  def display_score
    return self.score.to_s + " / " + settings.max_score.to_s
  end


end

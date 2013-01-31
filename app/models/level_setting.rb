class LevelSetting < ActiveRecord::Base
  attr_accessible :level, :max_score, :step, :admin, :password, :friends, :message, :info, :login, :post, :search_mode, :nearby, :plans
  self.primary_key = :level
   
end

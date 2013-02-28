# == Schema Information
#
# Table name: level_settings
#
#  level        :integer          not null, primary key
#  max_score    :integer
#  multi        :integer          default(0)
#  admin        :integer          default(0)
#  password     :integer          default(7)
#  friends      :integer          default(7)
#  message      :integer          default(0)
#  info         :integer          default(7)
#  login        :integer          default(7)
#  post         :integer          default(7)
#  search_mode  :integer          default(7)
#  nearby       :integer          default(7)
#  plans_value  :integer          default(1)
#  notify_users :integer          default(1)
#  invitations  :integer          default(10)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class LevelSetting < ActiveRecord::Base
  attr_accessible :level, :max_score, :step, :admin, :password, :friends, :message, :info, :login, :post, :search_mode, :nearby, :plans
  self.primary_key = :level
   
end

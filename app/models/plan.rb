class Plan < ActiveRecord::Base
  attr_accessible :loc, :mate, :name, :subj, :time, :user_id
  belongs_to  :user

  name_regex =   /^[[a-z]|_]+$/
  validates :name,  	presence:   	true,
  								    format:  		{ with: name_regex },
  								    length:     { maximum:  50 },
                      uniqueness:   { scope: :user_id, case_sensitive: false }


  def to_hash
  	res = []
  	res.push(["loc",  self.loc ]) if self.loc  && self.loc.size  > 2
  	res.push(["mate", self.mate]) if self.mate && self.mate.size > 2
  	res.push(["subj", self.subj]) if self.subj && self.subj.size > 0
  	res.push(["time", self.time]) if self.time && self.time.size > 2
  	Hash[res]
  end


  def auth_user
    @user = User.find_by_id(params[:id])
    redirect_to(root_path) unless (current_user.admin? || current_user?(@user))
  end
  
end

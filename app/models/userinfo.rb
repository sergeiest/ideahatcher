class Userinfo < ActiveRecord::Base
  attr_accessible :category_type, :content, :is_main, :status, :user_id

  belongs_to :user


  # Status:
  # 1 - experience
  # 2 - need

end

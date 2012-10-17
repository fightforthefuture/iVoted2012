class Post < ActiveRecord::Base
  attr_accessible :message, :platform, :screen_name, :user_id
  
  belongs_to :user
  
end

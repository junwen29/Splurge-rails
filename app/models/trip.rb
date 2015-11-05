class Trip < ActiveRecord::Base

  belongs_to :user

  # has_many :friends, :class_name => 'User', :foreign_key => 'friend_id', :through =>


  include Trip::Json

end

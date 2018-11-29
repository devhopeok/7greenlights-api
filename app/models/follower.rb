# == Schema Information
#
# Table name: followers
#
#  user_id           :integer
#  follower_user_id  :integer
#  friendship_status :integer
#

class Follower < ActiveRecord::Base
  include ViewResult

  belongs_to :user
  belongs_to :follower_user, class_name: User
end

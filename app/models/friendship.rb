# == Schema Information
#
# Table name: friendships
#
#  user_id   :integer
#  friend_id :integer
#

class Friendship < ActiveRecord::Base
  include ViewResult
  include Refreshable

  belongs_to :user
  belongs_to :friend, class_name: User
end

# == Schema Information
#
# Table name: friendships
#
#  user_id   :integer
#  friend_id :integer
#

require 'rails_helper'

RSpec.describe Friendship, type: :model do

    let!(:user_a)     { create :user }
    let!(:user_b)     { create :user }
    before :each do
      user_a.toggle_greenlight(user_b)
      user_b.toggle_greenlight(user_a)
    end
    it 'shows user_a friends' do
      friendship = Friendship.find_by(user_id: user_a.id)
      expect(friendship).not_to be_nil
      expect(friendship.friend_id).to eq(user_b.id)
    end

    it 'shows user_b friends' do
      friendship = Friendship.find_by(user_id: user_b.id)
      expect(friendship).not_to be_nil
      expect(friendship.friend_id).to eq(user_a.id)
    end
end

# == Schema Information
#
# Table name: blasts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  text       :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_blasts_on_user_id  (user_id)
#



FactoryGirl.define do
  factory :blast do
    user
    text  { Faker::Lorem.sentence }
  end
end

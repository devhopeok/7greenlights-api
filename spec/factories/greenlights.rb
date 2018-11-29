# == Schema Information
#
# Table name: greenlights
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  greenlighteable_id   :integer
#  greenlighteable_type :string
#  created_at           :datetime
#  updated_at           :datetime
#  friendship_status    :integer          default(0)
#
# Indexes
#
#  index_greenlighteable         (greenlighteable_type,greenlighteable_id)
#  index_greenlights_on_user_id  (user_id)
#

FactoryGirl.define do

  factory :greenlight do
    user

    trait :with_arena do
      association :greenlighteable, factory: :arena
    end

    trait :with_media_content do
      association :greenlighteable, factory: :media_content
    end

    trait :with_user do
      association :greenlighteable, factory: :user
    end

    trait :with_note do
      association :greenlighteable, factory: :note
    end
  end
end

# == Schema Information
#
# Table name: media_contents
#
#  id                :integer          not null, primary key
#  name              :string
#  media_url         :string
#  links             :json
#  is_hidden         :boolean          default(FALSE)
#  created_at        :datetime
#  updated_at        :datetime
#  user_id           :integer
#  greenlights_count :integer          default(0)
#  username          :string
#  content_type      :integer          default(0)
#  image             :string
#
# Indexes
#
#  index_media_contents_on_content_type  (content_type)
#  index_media_contents_on_is_hidden     (is_hidden)
#  index_media_contents_on_user_id       (user_id)
#  index_media_contents_on_username      (username)
#

FactoryGirl.define do

  factory :media_content do
    sequence :name do |n|
      "#{Faker::Lorem.word}-#{n}"
    end
    media_url { Faker::Internet.url }
    links do
      types = ['youtube', 'vimeo', 'soundcloud', 'other', 'bandcamp', 'etsy']
      ret = types.map { |type| {type: type, url: Faker::Internet.url}}
      ret.sample(rand(ret.length))
    end
    is_hidden false
    user

    trait :arena_including_image do
      association :arena, factory: :arena_with_image
    end
    factory :media_content_with_greenlights do
      transient do
        greenlight_count 50
      end
      user nil

      after(:create) do |media_content, evaluator|
        create_list(:greenlight, evaluator.greenlight_count, :with_media_content, greenlighteable: media_content, user: nil)
      end
    end
  end
end

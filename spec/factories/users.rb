# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default("")
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  authentication_token   :string           default("")
#  username               :string           default("")
#  created_at             :datetime
#  updated_at             :datetime
#  facebook_id            :string
#  instagram_id           :string
#  birthday               :date
#  greenlights_count      :integer          default(0)
#  picture                :string
#  social_media_links     :jsonb
#  about                  :text
#  goals                  :text
#  last_blast             :string
#  active                 :boolean          default(TRUE)
#  channel                :text
#  tooltips               :jsonb
#
# Indexes
#
#  index_users_on_active                (active)
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_facebook_id           (facebook_id) UNIQUE
#  index_users_on_instagram_id          (instagram_id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, class: 'User' do
    email     { Faker::Internet.email }
    password  { Faker::Internet.password(8) }
    sequence(:username) { |n| "#{n}#{Faker::Internet.user_name}" }
    goals  { Faker::Lorem.sentences.join }
    about  { Faker::Lorem.sentences.join }
    social_media_links do
      types = ['youtube', 'vimeo', 'soundcloud', 'other', 'bandcamp', 'etsy']
      ret = types.map { |type| {type: type, url: Faker::Internet.url}}
      ret.sample(rand(ret.length))
    end
    trait :with_fb do
      password    { nil }
      facebook_id { Faker::Crypto.md5 }
    end

    trait :with_instagram do
      password     { nil }
      instagram_id { Faker::Crypto.md5 }
    end

    factory :user_with_image do
      picture { Faker::Avatar.image('my-own-slug', '50x50', 'jpg') }
    end

    factory :user_with_media_content do
      transient do
        media_contents_count 3
      end

      after(:create) do |user, evaluator|
        create_list(:media_content, evaluator.media_contents_count, :arena_including_image, user: user)
      end
    end
  end
end

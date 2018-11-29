# == Schema Information
#
# Table name: arenas
#
#  id                :integer          not null, primary key
#  name              :string           default("")
#  image             :string
#  description       :string           default("")
#  end_date          :datetime         not null
#  created_at        :datetime
#  updated_at        :datetime
#  is_feature        :boolean          default(FALSE)
#  greenlights_count :integer          default(0)
#  blast             :text
#
# Indexes
#
#  index_arenas_on_is_feature  (is_feature)
#  index_arenas_on_name        (name) UNIQUE
#

FactoryGirl.define do

  factory :arena do
    sequence :name do |n|
      "#{Faker::Lorem.word}-#{n}"
    end
    is_feature false
    description  { Faker::Lorem.sentences.join  }
    end_date     { Faker::Time.forward(90) }

    transient do
      greenlights_counts 5
      media_content_counts 5
    end

    trait :is_feature do
      is_feature true
    end

    factory :arena_with_greenlights do
      after(:create) do |arena, evaluator|
        create_list(:greenlight, evaluator.greenlights_counts, greenlighteable: arena)
      end
    end

    factory :arena_with_image do
      image do
        images = ['art.jpeg', 'art2.jpg', 'eifel.jpeg',
                  'guitar.jpeg', 'headphones.jpeg',
                  'woods.jpeg', 'mountain.jpeg']
        File.new(Rails.root.join('spec', 'factories', 'images', 'arenas', images.sample))
      end
    end
  end
end

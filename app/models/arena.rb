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

class Arena < ActiveRecord::Base
  include Filterable
  include Sortable

  mount_uploader :image, ImageUploader

  has_many :greenlights, as: :greenlighteable, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :media_contents, through: :posts
  has_and_belongs_to_many :sponsors

  validates :name, presence: true, uniqueness: true, allow_blank: false, allow_nil: false
  validates :end_date, presence: true

  def media_contents_greenlights_count
    ArenaContentGreenlightsCount.find_by(arena_id: id).try(:sum) || 0
  end
end

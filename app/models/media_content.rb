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
class MediaContent < ActiveRecord::Base
  include Filterable
  include Sortable

  mount_uploader :image, ImageUploader

  enum content_type: [:other, :audio, :video]

  belongs_to :user
  has_many :posts, dependent: :destroy
  has_many :arenas, through: :posts
  has_many :greenlights,
           as: :greenlighteable,
           dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :featured_notes, -> { Note.featured }, class_name: Note
  has_many :reports, dependent: :destroy
  has_many :notifications,
           class_name: Notifications::Notification,
           foreign_key: :event_entity_id,
           dependent: :destroy
  validates :name, :media_url, presence: true
  before_create :set_username

  def reported?
    reports.exists?(solved: false)
  end

  def self.arenas_id_name
    select('arenas.id, arenas.name').joins(:arenas).uniq
  end

  def self.with_featured_notes
    eager_load(:featured_notes)
  end

  def self.not_reported(params = {})
    params_empty = params.empty?
    exists_sql =
      "NOT EXISTS (
        SELECT 1
        FROM reports
        WHERE media_contents.id = reports.media_content_id
              AND solved = 'f'
      )"
    or_sql = 'media_contents.user_id = ?' unless params_empty
    query = [exists_sql, or_sql].compact.join(' OR ')
    params_empty ? where(query) : where(query, params[:include_user])
  end

  private

  def set_username
    self.username = user.try(:username)
  end
end

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

class User < ActiveRecord::Base
  include Authenticable
  include SocialMediable

  mount_uploader :picture, ImageUploader

  attr_accessor :birthday_str

  has_many :greenlights, dependent: :destroy
  has_many :media_contents, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :blasts, dependent: :destroy, after_add: :update_last_blast
  has_many :reports, dependent: :destroy
  has_many :notifications,
           class_name: Notifications::Notification,
           foreign_key: :receiver_id
  has_many :friendships
  has_many :followers
  has_many :followings,
           class_name: Follower,
           foreign_key: 'follower_user_id'

  has_many :stream_items,
           through: :greenlights,
           source: :greenlighteable,
           source_type: MediaContent

  has_many :greenlit_users,
           through: :greenlights,
           source: :greenlighteable,
           source_type: User

  has_many :greenlit_arenas,
           through: :greenlights,
           source: :greenlighteable,
           source_type: Arena

  has_many :greenlights_by_users,
           as: :greenlighteable,
           dependent: :destroy,
           class_name: Greenlight

  has_many :friends,
           through: :friendships,
           source: :friend

  has_many :follower_users,
           through: :followers

  has_many :following_users,
           source: :user,
           through: :followings

  has_many :posted_arenas,
           source: :arena,
           through: :posts

  validates :username, uniqueness: { case_sensitive: false }
  validates :password, presence: true, unless: :social_mediable?, on: :create
  validates :facebook_id, :instagram_id,
            uniqueness: true,
            allow_blank: true,
            allow_nil: true,
            unless: 'password.present?', on: :create
  before_save :set_channel

  def greenlit?(target)
    greenlights.exists?(greenlighteable: target)
  end

  def media_content_greenlights_count
    media_contents.sum(:greenlights_count)
  end

  def toggle_greenlight(target)
    if target.is_a? User
      toggle_greenlight_user(target)
    else
      deleted_greenlights = greenlights.where(greenlighteable: target).destroy_all
      greenlights.create!(greenlighteable: target) unless deleted_greenlights.count > 0
    end
  end

  def pops_user_ids(pops)
    pops
      .delete_if { |pop| pop == :strangers }
      .keep_if   { |pop| Constants::POPULATION_TYPES.values.include?(pop) }
      .map       { |pop| public_send(pop).select(:id) }
      .inject(:union)
  end

  def tooltips
    read_attribute(:tooltips).presence || self.class.custom_tooltips_to_hash
  end

  def self.custom_tooltips
    @custom_tooltips ||= YAML.load(File.open("#{Rails.root}/config/custom_tooltips.yml", 'r')).map(&:to_sym)
  end

  private

  def self.custom_tooltips_to_hash
    {}.tap do |tooltips|
      custom_tooltips.each { |tooltip| tooltips[tooltip] = false }
    end
  end

  def to_s
    username
  end

  def social_mediable?
    facebook_id.present? || instagram_id.present?
  end

  def update_last_blast(blast)
    update_column :last_blast, blast.text
  end

  def toggle_greenlight_user(target)
    user_greenlight = greenlights.find_by(greenlighteable: target)
    user_greenlight.try(:update_greenlit_user_status)

    unless user_greenlight
      user_greenlight = greenlights_by_users.find_by(user: target)
      user_greenlight.try(:update_greenlight_by_user_status)
    end
    greenlights.create!(greenlighteable: target, friendship_status: :following) unless user_greenlight
  end

  def set_channel
    self.channel = Digest::SHA2.hexdigest(email)
  end
end

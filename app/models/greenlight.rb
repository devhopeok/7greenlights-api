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

class Greenlight < ActiveRecord::Base
  enum friendship_status: [:initial, :being_followed, :following, :friends]

  belongs_to :user
  belongs_to :greenlighteable,
             polymorphic: true

  after_create :increment_counters
  after_create :update_arena_content_greenlights_count, if: -> { greenlighteable.is_a? MediaContent }
  after_create :notify_user_greenlit, if: -> { greenlighteable.is_a? User }
  after_create :notify_note_media_greenlit, if: -> {  greenlighteable_is_a? MediaContent, Note }
  after_destroy :update_arena_content_greenlights_count, if: -> { greenlighteable.is_a? MediaContent }
  after_destroy :decrement_counters
  after_update :update_friendships, if: :friendship_status_changed?

  def update_greenlight_by_user_status
    case friendship_status.to_sym
    when :being_followed
      destroy
    when :following
      notify_greenlight_by_user
      user.try :increment!, :greenlights_count
      friends!
    when :friends
      user.try :decrement!, :greenlights_count
      following!
    end
  end

  def update_greenlit_user_status
    case friendship_status.to_sym
    when :being_followed
      notify_user_greenlit
      greenlighteable.try :increment!, :greenlights_count
      friends!
    when :following
      destroy
    when :friends
      greenlighteable.try :decrement!, :greenlights_count
      being_followed!
    end
  end

  private

  def greenlighteable_is_a?(*args)
    args.reduce(false) { |val, obj| val || greenlighteable.is_a?(obj) }
  end

  def increment_counters
    greenlighteable.try :increment!, :greenlights_count
  end

  def decrement_counters
    greenlighteable.try :decrement!, :greenlights_count if greenlighteable.greenlights_count > 0
  end

  def notify_user_greenlit
    Notifications::UserGreenlit.create(
      event_entity: greenlighteable,
      sender: user,
      receiver: greenlighteable
    )
  end

  def notify_greenlight_by_user
    Notifications::UserGreenlit.create(
      event_entity: user,
      sender: greenlighteable,
      receiver: user
    )
  end

  def notify_note_media_greenlit
    "Notifications::#{greenlighteable_type}Greenlit".constantize
      .create(
        event_entity: greenlighteable,
        sender: user,
        receiver: greenlighteable.user
      )
  end

  def update_arena_content_greenlights_count
    ArenaContentGreenlightsCount.refresh
  end

  def update_friendships
    Friendship.refresh if friendship_status.to_sym == :friends || friendship_status_was.to_sym == :friends
  end
end

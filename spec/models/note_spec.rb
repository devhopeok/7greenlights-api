# == Schema Information
#
# Table name: notes
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  media_content_id  :integer
#  image             :string
#  created_at        :datetime
#  updated_at        :datetime
#  order             :integer          default(0)
#  is_feature        :boolean          default(FALSE)
#  greenlights_count :integer
#
# Indexes
#
#  index_notes_on_is_feature        (is_feature)
#  index_notes_on_media_content_id  (media_content_id)
#  index_notes_on_order             (order)
#  index_notes_on_user_id           (user_id)
#

require 'spec_helper'

describe Note, type: :model  do
  describe 'notification' do
    let!(:user)   { create :user }
    let!(:user_b) { create :user }
    let!(:media)  { create :media_content, user: user }
    let!(:note)   { create :note, media_content: media, user: user_b }

    context 'greenlight' do
      it do
        user.toggle_greenlight(note)
        notification = Notifications::NoteGreenlit.find_by(
          event_entity: note,
          sender: user,
          receiver: user_b
        )
        expect(notification).not_to be_nil
      end
    end

    context 'creation' do
      it do
        notification = Notifications::NoteUploaded.find_by(
          event_entity: note,
          sender: note.user,
          receiver: media.user
        )
        expect(notification).not_to be_nil
      end
    end

    context 'feature' do
      it do
        note.update(is_feature: true)
        notification = Notifications::NoteFeatured.find_by(
          event_entity: note,
          sender: media.user,
          receiver: note.user
        )
        expect(notification).not_to be_nil
      end
    end
  end
end

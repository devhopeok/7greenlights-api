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

require 'spec_helper'

describe User, type: :model  do

  describe 'Validations' do
    subject { build :user }

    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_uniqueness_of(:email).case_insensitive }

    describe 'password' do
      context 'social media identification' do
        subject { build :user, :with_fb }
        it      { should_not validate_presence_of(:password) }
      end

      context 'normal identification' do
        subject { build :user }
        it      { should validate_presence_of(:password) }
      end
    end

    describe 'facebook_id and instagram_id' do
      context 'social media identification' do
        context 'facebook_id allow blank or nil' do
          subject { build :user, :with_instagram }
          it      { should validate_uniqueness_of(:facebook_id).allow_nil }
          it      { should validate_uniqueness_of(:facebook_id).allow_blank }
        end

        context 'instagram_id allow blank or nil' do
          subject { build :user, :with_fb }
          it      { should validate_uniqueness_of(:instagram_id).allow_nil }
          it      { should validate_uniqueness_of(:instagram_id).allow_blank }
        end
      end

      context 'normal identification' do
        subject { build :user }
        it      { should_not validate_uniqueness_of(:facebook_id) }
        it      { should_not validate_uniqueness_of(:instagram_id) }
      end
    end
  end

  describe 'Associations' do
    it { is_expected.to have_many(:greenlights) }
  end

  describe 'toggle_greenlight' do
    let(:user)   { create :user  }
    let!(:arena) { create :arena }

    context 'on arena' do
      context 'not greenlit' do
        it 'creates associated greenlight' do
          user.toggle_greenlight(arena)
          greenlight = user.greenlights.find_by(greenlighteable: arena)
          expect(greenlight).not_to be_nil
        end
      end

      context 'previously greenlit' do
        let!(:greenlight) { create :greenlight, :with_arena, user: user, greenlighteable: arena }
        it 'removes associated greenlight' do
          user.toggle_greenlight(arena)
          db_greenlight = user.greenlights.find_by(id: greenlight.id)
          expect(db_greenlight).to be_nil
        end
      end
    end

    context 'on user' do
      let!(:user_a) { create :user }
      let!(:user_b) { create :user }

      context 'not greenlit' do
        before :each do
          user_a.toggle_greenlight(user_b)
          @greenlight = user_a.greenlights.find_by(greenlighteable: user_b)
        end

        it 'creates associated greenlight' do
          expect(@greenlight).not_to be_nil
        end

        it 'with status following' do
          expect(@greenlight.following?).to eq(true)
        end

        it 'increment greenlight count' do
          expect(user_b.greenlights_count).to eq(1)
        end
      end

      context 'previously greenlit by me' do
        let!(:greenlight) { create :greenlight, :with_user, user: user_a, greenlighteable: user_b, friendship_status: :following }

        it 'removes associated greenlight' do
          user_a.toggle_greenlight(user_b)
          @db_greenlight = user_a.greenlights.find_by(id: greenlight.id)
          expect(@db_greenlight).to be_nil
        end

        it 'decrement greenlight count' do
          user_a.toggle_greenlight(user_b)
          user_b.reload
          expect(user_b.greenlights_count).to eq(0)
        end

        context 'and then by other user' do
          let!(:greenlight) { create :greenlight, :with_user, user: user_a, greenlighteable: user_b, friendship_status: :friends }

          it 'change greenlight status to being_followed' do
            user_a.toggle_greenlight(user_b)
            greenlight.reload
            expect(greenlight.being_followed?).to eq(true)
          end

          it 'decrement greenlight count for user b' do
            user_a.toggle_greenlight(user_b)
            user_b.reload
            expect(user_b.greenlights_count).to eq(0)
          end
        end
      end

      context 'previously greenlit by other' do
        let!(:greenlight) { create :greenlight, :with_user, user: user_b, greenlighteable: user_a, friendship_status: :following }

        before :each do
          user_a.toggle_greenlight(user_b)
          @db_greenlight = user_a.greenlights_by_users.find_by(id: greenlight.id)
        end

        it 'change greenlight status to friends' do
          expect(@db_greenlight.friends?).to eq(true)
        end

        it 'increment greenlight count' do
          user_b.reload
          expect(user_b.greenlights_count).to eq(1)
        end

        context 'and then by me' do
          let!(:greenlight) { create :greenlight, :with_user, user: user_b, greenlighteable: user_a, friendship_status: :friends }

          before :each do
            user_a.toggle_greenlight(user_b)
          end

          it 'change greenlight status to following' do
            expect(@db_greenlight.following?).to eq(true)
          end

          it 'decrement greenlight count' do
            expect(user_b.greenlights_count).to eq(0)
          end
        end
      end
    end

    describe 'greenlit?' do
      let(:user)   { create :user  }
      let(:arena) { create :arena }
      let(:arena_aux) { create :arena }
      let!(:greenlight) { create :greenlight, user: user, greenlighteable: arena }

      context 'user greenlit arena' do
        it do
          result = user.greenlit?(arena)
          expect(result).to eq(true)
        end
      end

      context 'user didnt greenlight arena' do
        it do
          result = user.greenlit?(arena_aux)
          expect(result).to eq(false)
        end
      end
    end
  end

  describe 'notification' do
    let(:user_a)   { create :user }
    let(:user_b)   { create :user }

    context 'greenlight' do
      it do
        user_a.toggle_greenlight(user_b)
        notification = Notifications::UserGreenlit.find_by(
          event_entity: user_b,
          sender: user_a,
          receiver: user_b
        )
        expect(notification).not_to be_nil
      end
    end

    context 'already greenlit' do
      it do
        user_a.toggle_greenlight(user_b)
        user_b.toggle_greenlight(user_a)

        notification = Notifications::UserGreenlit.find_by(
          event_entity: user_a,
          sender: user_b,
          receiver: user_a
        )
        expect(notification).not_to be_nil
      end
    end
  end

  describe '#tooltips' do
    let(:custom_tooltips) { User.custom_tooltips_to_hash }

    context 'when is nil' do
      let(:user)   { create :user, tooltips: nil }

      it do
        tooltips = user.tooltips
        expect(tooltips).to eq(custom_tooltips)
      end
    end

    context 'when was updated' do
      let(:updated_tooltips) do
        ret = custom_tooltips.clone
        ret[ret.keys.first] = true
        ret
      end
      let(:user) { create :user, tooltips: updated_tooltips }

      it do
        tooltips = user.tooltips
        expect(tooltips.to_json).to eq(updated_tooltips.to_json)
      end
    end
  end
end

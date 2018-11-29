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

require 'spec_helper'

describe Greenlight, type: :model  do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:greenlighteable) }
  end

  describe 'update_greenlight_by_user_status' do
    subject { create :greenlight, :with_user}

    context 'when being_followed' do
      it do
        subject.update_attribute(:friendship_status, :being_followed)
        subject.update_greenlight_by_user_status
        expect(subject.destroyed?).to eq(true)
      end
    end

    context 'when following' do
      it do
        subject.update_attribute(:friendship_status, :following)
        subject.update_greenlight_by_user_status
        expect(subject.friends?).to eq(true)
      end
    end

    context 'when friends' do
      it do
        subject.update_attribute(:friendship_status, :friends)
        subject.update_greenlight_by_user_status
        expect(subject.following?).to eq(true)
      end
    end
  end

  describe 'update_greenlit_user_status' do
    let(:user) { create :user }
    subject    { create :greenlight, :with_user, greenlighteable: user }

    context 'when being_followed' do
      it do
        subject.update_attribute(:friendship_status, :being_followed)
        subject.update_greenlit_user_status
        expect(subject.friends?).to eq(true)
      end
    end

    context 'when following' do
      it do
        subject.update_attribute(:friendship_status, :following)
        subject.update_greenlit_user_status
        expect(subject.destroyed?).to eq(true)
      end
    end

    context 'when friends' do
      it do
        subject.update_attribute(:friendship_status, :friends)
        subject.update_greenlit_user_status
        expect(subject.being_followed?).to eq(true)
      end
    end
  end
end

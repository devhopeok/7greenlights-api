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

require 'spec_helper'

describe Arena, type: :model  do

  describe 'Validations' do
    subject { build :arena }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:end_date) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:greenlights) }
  end

  describe 'Greenlights Counts' do
    subject { create :arena_with_greenlights, greenlights_counts: 4 }
    it do
      expect(subject.greenlights_count).to eq(4)
    end
  end

  describe 'Media Content greenlights count' do
    let(:greenlight_count1) { 7 }
    let(:greenlight_count2) { 5 }
    subject(:arena)         { create :arena }
    let!(:media_content1)   { create :media_content }
    let!(:media_content2)   { create :media_content }
    let!(:post1)            { create :post, media_content: media_content1, arena: arena }
    let!(:post2)            { create :post, media_content: media_content2, arena: arena }
    let!(:greenlight1)      { create_list :greenlight, greenlight_count1, :with_media_content, greenlighteable: media_content1 }
    let!(:greenlight2)      { create_list :greenlight, greenlight_count2, :with_media_content, greenlighteable: media_content2 }

    it do
      expect(arena.media_contents_greenlights_count).to eq(greenlight_count1 + greenlight_count2)
    end
  end

  describe 'self.sorted' do
    let(:sort_type) do
      {
        time_remaining: 0,
        total_greenlight: 1,
        alphabetically: 2,
        created_at: 3
      }
    end

    let(:sorting_attribute) do
      {
        0 => :end_date,
        1 => :greenlights_count,
        2 => :name,
        3 => :created_at
      }
    end

    let(:order_type) do
      {
        ascending: 0,
        descending: 1
      }
    end

    def test_ascending(arr, attribute)
      expect(arr.first.send(attribute)).to be < arr.second.send(attribute)
    end

    def test_descending(arr, attribute)
      expect(arr.first.send(attribute)).to be > arr.second.send(attribute)
    end

    describe 'by alphabetically' do
      let!(:arena_1) { create :arena, name: 'a' }
      let!(:arena_2) { create :arena, name: 'b' }

      context 'Ascendant' do
        it do
          sort = sort_type[:alphabetically]
          arenas = Arena.sorted(sort_type: sort, order_type: order_type[:ascending])
          test_ascending(arenas, sorting_attribute[sort])
        end
      end

      context 'Descendant' do
        it do
          sort = sort_type[:alphabetically]
          arenas = Arena.sorted(sort_type: sort, order_type: order_type[:descending])
          test_descending(arenas, sorting_attribute[sort])
        end
      end
    end

    describe 'by time remaining' do
      let!(:arena_1) { create :arena, end_date: DateTime.now }
      let!(:arena_2) { create :arena, end_date: 1.week.from_now }

      context 'shortest' do
        it do
          sort = sort_type[:time_remaining]
          arenas = Arena.sorted(sort_type: sort, order_type: order_type[:ascending])
          test_ascending(arenas, sorting_attribute[sort])
        end
      end

      context 'longest' do
        it do
          sort = sort_type[:time_remaining]
          arenas = Arena.sorted(sort_type: sort, order_type: order_type[:descending])
          test_descending(arenas, sorting_attribute[sort])
        end
      end
    end

    describe 'total greenlights' do
      let!(:arena_1) { create :arena, greenlights_count: 1 }
      let!(:arena_2) { create :arena, greenlights_count: 2 }

      context 'least' do
        it do
          sort = sort_type[:total_greenlight]
          arenas = Arena.sorted(sort_type: sort, order_type: order_type[:ascending])
          test_ascending(arenas, sorting_attribute[sort])
        end
      end

      context 'most' do
        it do
          sort = sort_type[:total_greenlight]
          arenas = Arena.sorted(sort_type: sort, order_type: order_type[:descending])
          test_descending(arenas, sorting_attribute[sort])
        end
      end
    end

    describe 'created_at' do
      let!(:arena_1) { create :arena }
      let!(:arena_2) { create :arena, created_at: 1.year.from_now }

      context 'oldest' do
        it do
          sort = sort_type[:created_at]
          arenas = Arena.sorted(sort_type: sort, order_type: order_type[:ascending])
          test_ascending(arenas, sorting_attribute[sort])
        end
      end

      context 'newest' do
        it do
          sort = sort_type[:created_at]
          arenas = Arena.sorted(sort_type: sort, order_type: order_type[:descending])
          test_descending(arenas, sorting_attribute[sort])
        end
      end
    end
  end
  describe 'self.filtered' do

    let(:filter_type) do
      {
        active:      0,
        greenlit:    1,
        archived:    2,
        feature:     3,
        non_feature: 4
      }
    end

    let(:total_feature_arenas)     { 5 }
    let(:total_non_feature_arenas) { 5 }
    let!(:feature_arenas)          { create_list :arena, total_feature_arenas, :is_feature }
    let!(:non_feature_arenas)      { create_list :arena, total_non_feature_arenas }
    let!(:active_arena)            { create :arena, end_date: 1.year.from_now}
    let!(:archived_arena)          { create :arena, end_date: 1.year.ago}

    context 'by feature' do
      it 'returns only feature arenas' do
        arenas = Arena.filtered(filter_types: [filter_type[:feature]])
        expect(arenas.any? { |elem| elem.is_feature == false }).to eq false
      end
    end

    context 'by non feature' do
      it 'returns only non feature arenas' do
        arenas = Arena.filtered(filter_types: [filter_type[:non_feature]])
        expect(arenas.any? { |elem| elem.is_feature == true }).to eq false
      end
    end

    context 'active' do
      it 'returns only active arenas' do
        arenas = Arena.filtered(filter_types: [filter_type[:active]])
        expect(arenas.any? { |elem| elem.end_date <  DateTime.now }).to eq false
      end
    end

    context 'archived' do
      it 'returns only archived arenas' do
        arenas = Arena.filtered(filter_types: [filter_type[:archived]])
        expect(arenas.any? { |elem| elem.end_date >  DateTime.now }).to eq false
      end
    end

    context 'greenlit' do
      let!(:user)   { create :user }
      let!(:arena)  { create :arena }
      before(:each) do
        user.toggle_greenlight(arena)
      end

      it 'returns only greenlit arenas by user' do
        arenas = Arena.filtered(filter_types: [filter_type[:greenlit]],
                                user: user)
        expect(arenas.any? { |elem| user.greenlit?(elem) == false }).to eq false
      end

      context 'and archived' do
        it 'returns only greenlit arenas by user and archived' do
          arenas = Arena.filtered(filter_types: [filter_type[:greenlit], filter_type[:archived]],
                                  user: user)
          expect(arenas.any? do |elem|
             user.greenlit?(elem) == false || elem.end_date <  DateTime.now
          end).to eq false
        end
      end
    end
  end
end

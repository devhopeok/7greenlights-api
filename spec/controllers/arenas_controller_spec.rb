# encoding: utf-8

require 'spec_helper'

describe Api::V1::ArenasController do
  render_views

  describe 'GET Index' do
    let(:total_arenas) { 10 }
    let(:page)         { 1 }
    let(:per_page)     { 2 }
    let(:total_pages)  { total_arenas / per_page }

    context 'all arenas' do
      let!(:arenas)      { create_list :arena, total_arenas }

      before :each do
        get :index, page: page, per_page: per_page, format: 'json'
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns list of paginated arenas' do
        resp = parse_response response
        expect(resp['arenas']).to be_a(Array)
        expect(resp['arenas'].size).to eq(per_page)
        expect(resp['current_page']).to eq(page)
        expect(resp['total_pages']).to eq(total_pages)
        expect(resp['per_page']).to eq(per_page)
      end
    end
    describe 'filter' do

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

      let!(:feature_arenas)     { create_list :arena, total_feature_arenas, :is_feature }
      let!(:non_feature_arenas) { create_list :arena, total_non_feature_arenas }
      let!(:active_arena) { create :arena, end_date: 1.year.from_now}
      let!(:archived_arena) { create :arena, end_date: 1.year.ago}

      context 'by feature' do
        it 'returns only feature arenas' do
          get :index, filters: [filter_type[:feature]], format: 'json'
          resp = parse_response response
          expect(resp['arenas'].any? { |elem| elem['is_feature'] == false }).to eq false
        end
      end

      context 'by non feature' do
        it 'returns only non feature arenas' do
          get :index, filters: [filter_type[:non_feature]], format: 'json'
          resp = parse_response response
          expect(resp['arenas'].any? { |elem| elem['is_feature'] == true }).to eq false
        end
      end

      context 'active' do
        it 'returns only active arenas' do
          get :index, filters: [filter_type[:active]], format: 'json'
          resp = parse_response response
          expect(resp['arenas'].any? { |elem| elem['end_date'] <  DateTime.now }).to eq false
        end
      end

      context 'archived' do
        it 'returns only archived arenas' do
          get :index, filters: [filter_type[:archived]], format: 'json'
          resp = parse_response response
          expect(resp['arenas'].any? { |elem| elem['end_date'] >  DateTime.now }).to eq false
        end
      end

      context 'greenlit' do
        let!(:user)   { create :user }
        let!(:arena)  { create :arena }
        before(:each) do
          user.toggle_greenlight(arena)
          sign_in user
        end

        it 'returns only greenlit arenas by user' do
          get :index, filters: [filter_type[:greenlit]], format: 'json'
          resp = parse_response response
          expect(resp['arenas'].any? { |elem| elem['greenlit'] == false }).to eq false
        end
      end
    end

    describe 'sort' do

      let(:sort_type) do
        {
          time_remaining:   0,
          total_greenlight: 1,
          alphabetically:   2,
          created_at:       3
        }
      end

      let(:order_type) do
        {
          ascending:  0,
          descending: 1
        }
      end

      def test_ascending
        parsed_response = parse_response response
        expected_ids = [arena_1.id, arena_2.id]
        arenas_ids = parsed_response['arenas'].map { |a| a['id'] }
        expect(arenas_ids).to eq(expected_ids)
      end

      def test_descending
        parsed_response = parse_response response
        expected_ids = [arena_2.id, arena_1.id]
        arenas_ids = parsed_response['arenas'].map { |a| a['id'] }
        expect(arenas_ids).to eq(expected_ids)
      end

      describe 'by alphabetically' do
        let!(:arena_1) { create :arena, name: 'a' }
        let!(:arena_2) { create :arena, name: 'b' }

        context 'Ascendant' do
          it do
            get :index, sort: sort_type[:alphabetically], order: order_type[:ascending], format: :json
            test_ascending
          end
        end

        context 'Descendant' do
          it do
            get :index, sort: sort_type[:alphabetically], order: order_type[:descending], format: :json
            test_descending
          end
        end
      end

      describe 'by time remaining' do
        let!(:arena_1) { create :arena, end_date: DateTime.now }
        let!(:arena_2) { create :arena, end_date: 1.week.from_now }

        context 'shortest' do
          it do
            get :index, sort: sort_type[:time_remaining], order: order_type[:ascending], format: :json
            test_ascending
          end
        end

        context 'longest' do
          it do
            get :index, sort: sort_type[:time_remaining], order: order_type[:descending], format: :json
            test_descending
          end
        end
      end

      describe 'total greenlights' do
        let!(:arena_1) { create :arena, greenlights_count: 1 }
        let!(:arena_2) { create :arena, greenlights_count: 2 }

        context 'least' do
          it do
            get :index, sort: sort_type[:total_greenlight], order: order_type[:ascending], format: :json
            test_ascending
          end
        end

        context 'most' do
          it do
            get :index, sort: sort_type[:total_greenlight], order: order_type[:descending], format: :json
            test_descending
          end
        end
      end

      describe 'created_at' do
        let!(:arena_1) { create :arena }
        let!(:arena_2) { create :arena, created_at: 1.year.from_now }

        context 'oldest' do
          it do
            get :index, sort: sort_type[:created_at], order: order_type[:ascending], format: :json
            test_ascending
          end
        end

        context 'newest' do
          it do
            get :index, sort: sort_type[:created_at], order: order_type[:descending], format: :json
            test_descending
          end
        end
      end
    end
  end

  describe 'GET Show' do
    let(:greenlight_counts) { 4 }
    subject(:arena) { create :arena_with_greenlights, greenlights_counts: greenlight_counts }

    before :each do
      get :show, id: arena.id, format: 'json'
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns an arena' do
      resp = parse_response response
      expect(resp['id']).to eq(arena.id)
      expect(resp['name']).to eq(arena.name)
      expect(resp['description']).to eq(arena.description)
      expect(resp['end_date'].to_datetime).to eq(arena.end_date)
    end

    context 'with greenlights' do
      it 'returns arena with greenlights count' do
        resp = parse_response response
        expect(resp['greenlights_count']).to eq(greenlight_counts)
      end
    end

    context 'user logged in' do
      let(:user) { create :user }
      let!(:greenlights) { create_list :greenlight, 5, :with_arena, user: user }

      it 'returns arenas list with greenlit arenas marked' do
        sign_in user
        get :index, page: 0, per_page: 15, format: 'json'
        resp = parse_response response
        greenlit_arenas =
          resp['arenas'].select do |elem|
            elem['greenlit'] == true
          end
        expect(greenlit_arenas.count).to eq(5)
      end
    end
  end

  describe 'POST Greenlight' do
    let(:arena) { create :arena }
    subject(:user) { create :user }

    before(:each) { sign_in user }

    it 'returns success' do
      post :greenlight, id: arena.id, format: 'json'
      expect(response).to have_http_status(:no_content)
    end

    it 'greenlight an arena' do
      expect {
        post :greenlight, id: arena.id, format: 'json'
      }.to change {
        user.greenlights.count
      }.from(0).to(1)
      greenlight = user.greenlights.first
      greenlight_arena = greenlight.greenlighteable
      expect(greenlight_arena.id).to eq(arena.id)
    end

    context 'arena already greenlit' do
      let!(:greenlight) { create :greenlight, :with_arena, user: user, greenlighteable: arena }

      it 'ungreenlit arena' do
        expect {
          post :greenlight, id: arena.id, format: 'json'
        }.to change {
          user.greenlights.count
        }.from(1).to(0)
        expect(Greenlight.find_by(id: greenlight.id)).to be_nil
      end
    end
  end
 end

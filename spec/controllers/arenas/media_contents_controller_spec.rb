# encoding: utf-8

require 'spec_helper'

describe Api::V1::Arenas::MediaContentsController do
  render_views
  let!(:user) { create :user }
  let!(:arena) { create :arena }
  before(:each) { sign_in user }

  describe 'GET Index' do
    let!(:post) { create_list :post, 5, arena: arena }

    it 'returns success' do
      get :index, arena_id: arena.id, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns list of arenas' do
      get :index, arena_id: arena.id, format: :json
      resp = parse_response response
      response_ids = resp['media_contents'].map{ |m| m['id'] }
      posts_ids = MediaContent.all.pluck(:id)
      expect(response_ids).to match_array(posts_ids)
    end
  end
end

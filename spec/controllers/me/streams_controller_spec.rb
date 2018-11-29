# encoding: utf-8

require 'spec_helper'

describe Api::V1::Me::StreamsController do
  render_views
  let!(:user) { create :user }
  let(:media_content) { create :media_content, user: user }
  before(:each) { sign_in user }

  describe 'GET Index' do
    let(:media_greenlit_count) { 5 }
    let!(:media_greenlit) { create_list :greenlight, media_greenlit_count, :with_media_content, user: user }
    let!(:media_greenlit_other_user) { create_list :greenlight, 2, :with_media_content }
    it 'returns success' do
      get :index, user_id: user.id, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns array of media content greenlit' do
      get :index, user_id: user.id, format: :json
      resp = parse_response response
      expect(resp['stream']).not_to be_nil
      expect(resp['stream'].size).to eq(media_greenlit_count)
    end
  end
end

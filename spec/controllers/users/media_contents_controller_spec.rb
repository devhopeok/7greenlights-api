# encoding: utf-8

require 'spec_helper'

describe Api::V1::Users::MediaContentsController do
  render_views
  let!(:user) { create :user }
  let(:attrs) { attributes_for :media_content }
  let(:media_content) { create :media_content, user: user }
  before(:each) { sign_in user }

  describe 'GET Index' do
    let!(:media_contents) { create_list :media_content, 3, user: user }

    it 'returns success' do
      get :index, user_id: user.id, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns media contents' do
      get :index, user_id: user.id, format: :json
      parsed_response = parse_response response
      response_ids = parsed_response['media_contents'].map{ |m| m['id'] }
      media_contents_ids = media_contents.map{ |m| m[:id] }
      expect(response_ids).to match_array(media_contents_ids)
    end

    context 'when media is requested' do
      it 'returns media content' do
        media_content_id = media_contents[0][:id]
        get :index, user_id: user.id, media_content_id: media_content_id, format: :json
        expect(parse_response(response)['media_requested']['id']).to eq(media_content_id)
      end
    end
  end
end

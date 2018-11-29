# encoding: utf-8

require 'spec_helper'

describe Api::V1::Me::MediaContentsController do
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

    context 'when media is requested' do
      it 'returns media content' do
        media_content_id = media_contents.first[:id]
        get :index, user_id: user.id, media_content_id: media_content_id, format: :json
        expect(parse_response(response)['media_requested']['id']).to eq(media_contents.first[:id])
      end
    end
  end

  describe 'PUT Update' do
    it 'returns success' do
      put :update, user_id: user.id, id: media_content.id, media_content: attrs, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns updated resource' do
      put :update, user_id: user.id, id: media_content.id, media_content: attrs, format: :json
      resp = parse_response(response)
      expect(resp['name']).to eq(attrs[:name])
    end
  end

  describe 'POST Create' do
    it 'returns success' do
      post :create, user_id: user.id, media_content: attrs, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns created media content' do
      post :create, user_id: user.id, media_content: attrs, format: :json
      resp = parse_response response
      expect(resp['name']). to eq(attrs[:name])
      expect(resp['media_url']). to eq(attrs[:media_url])
      expect(resp['links'].to_json). to eq(attrs[:links].to_json)

    end
  end

  describe 'DELETE Destroy' do
    it 'returns ok' do
      delete :destroy, id: media_content.id, format: :json
      expect(response).to have_http_status(:no_content)
    end

    it 'deletes record' do
      delete :destroy, id: media_content.id, format: :json
      expect(MediaContent.find_by(id: media_content.id)).to eq(nil)
    end
  end
end

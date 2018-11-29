# encoding: utf-8

require 'spec_helper'

describe Api::V1::UsersController do
  render_views
  let!(:user) { create :user }
  let(:user_a) { create :user }
  let(:user_b) { create :user }

  describe 'Greenlight' do

    before(:each) { sign_in user_a}
    it 'returns 204' do
      post :greenlight, id: user_b.id, format: :json
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'profile' do
    let(:media_contents_count) { 3 }
    let(:greenlights_count) { 3 }
    let!(:media_contents) do
      create_list :media_content_with_greenlights,
                  media_contents_count,
                  greenlight_count: greenlights_count,
                  user: user
    end
    before(:each) do
      sign_in user
      user_a.toggle_greenlight(user)
      user_b.toggle_greenlight(user)
      user_a.toggle_greenlight(user.media_contents.first)
      user_b.toggle_greenlight(user.media_contents.second)
    end

    describe 'GET Show' do

      it 'returns success' do
        get :show, id: user.id, format: :json
        expect(response).to have_http_status(:success)
      end

      it 'returns profile information' do
        get :show, id: user.id, format: :json
        resp = parse_response response
        expect(resp['about']).to eq(user.about)
        expect(resp['goals']).to eq(user.goals)
        expect(resp['social_media_links']).to eq(user.social_media_links)
        expect(resp['greenlights_received']).to eq(user.greenlights_count)
        expect(resp['greenlights_to_media']).to eq(user.media_content_greenlights_count)
      end
    end
  end
end

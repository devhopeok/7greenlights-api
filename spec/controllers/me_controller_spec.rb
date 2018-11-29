# encoding: utf-8
require 'spec_helper'

describe Api::V1::MeController do
  render_views
  let!(:user)   { create :user }
  let!(:user_b) { create :user }
  let!(:user_c) { create :user }
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
    user_b.toggle_greenlight(user)
    user_c.toggle_greenlight(user)
    user_b.toggle_greenlight(user.media_contents.first)
    user_c.toggle_greenlight(user.media_contents.second)
  end

  describe 'GET Show' do

    it 'returns success' do
      get :show, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns profile information' do
      get :show, format: :json
      resp = parse_response response
      expect(resp['about']).to eq(user.about)
      expect(resp['goals']).to eq(user.goals)
      expect(resp['social_media_links']).to eq(user.social_media_links)
      expect(resp['greenlights_received']).to eq(user.greenlights_count)
      expect(resp['greenlights_to_media']).to eq(user.media_content_greenlights_count)
    end
  end

  describe 'PUT Update' do
    let(:attrs) do
      {
        username: Faker::Lorem.word,
        about: Faker::Lorem.sentences.join,
        goals: Faker::Lorem.sentences.join,
        social_media_links: [{ type: Faker::Lorem.word, url: Faker::Internet.url }],
        tooltips: { User.custom_tooltips.first => true }
      }
    end
    it 'returns success' do
      put :update, user: attrs, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns profile information' do
      put :update, user: attrs, format: :json
      resp = parse_response response
      expect(resp['username']).to eq(attrs[:username])
      expect(resp['about']).to eq(attrs[:about])
      expect(resp['goals']).to eq(attrs[:goals])
      expect(resp['social_media_links'].to_json).to eq(attrs[:social_media_links].to_json)
      expect(resp['tooltips'].to_json).to eq(attrs[:tooltips].to_json)
    end
  end
end

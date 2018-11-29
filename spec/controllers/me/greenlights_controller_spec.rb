# encoding: utf-8

require 'spec_helper'

describe Api::V1::Me::GreenlightsController do
  render_views
  let!(:user)   { create :user }
  let!(:user_b) { create :user }

  before(:each) do
    sign_in user
    user.toggle_greenlight(user_b)
  end

  describe 'GET Users' do
    it 'returns success' do
      get :users, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns users greenlit by signed in user' do
      get :users, format: :json
      parsed_response = parse_response response
      user = parsed_response['users'][0]
      expect(user['id']).to eq(user_b.id)
    end
  end
end

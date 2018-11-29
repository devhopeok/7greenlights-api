# encoding: utf-8

require 'spec_helper'

describe Api::V1::Users::GreenlightsController do
  render_views
  let!(:user)   { create :user }
  let!(:user_b) { create :user }
  let!(:user_c) { create :user }

  before(:each) do
    sign_in user
    user_b.toggle_greenlight(user_c)
  end

  describe 'GET Users' do
    it 'returns success' do
      get :users, id: user_b.id, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns users greenlit by signed in user' do
      get :users, id: user_b.id, format: :json
      parsed_response = parse_response response
      db_user = parsed_response['users'][0]
      expect(db_user['id']).to eq(user_c.id)
    end
  end
end

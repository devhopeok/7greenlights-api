# encoding: utf-8

require 'spec_helper'

describe Api::V1::Users::BlastsController do
  render_views
  let(:number_of_blasts) { 5 }
  let!(:user)            { create :user }
  let!(:user_b)          { create :user }

  before(:each) do
    sign_in user
  end

  describe 'GET Index' do
    let!(:blasts) { create_list :blast, number_of_blasts, user: user_b }
    it do
      get :index, user_id: user_b.id, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns blasts' do
      get :index, user_id: user_b.id, format: :json
      parsed_response = parse_response response
      response_ids = parsed_response['blasts'].map { |b| b['id'] }
      db_ids = blasts.map(&:id)
      expect(response_ids).to eq(db_ids)
    end
  end
end

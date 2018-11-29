# encoding: utf-8

require 'spec_helper'

describe Api::V1::Me::BlastsController do
  render_views
  let(:number_of_blasts) { 5 }
  let!(:user)            { create :user }

  before(:each) do
    sign_in user
  end

  describe 'GET Index' do
    let!(:blasts) { create_list :blast, number_of_blasts, user: user }
    subject { get :index, format: :json }

    it 'returns success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns blasts' do
      subject
      parsed_response = parse_response response
      response_ids = parsed_response['blasts'].map { |b| b['id'] }
      db_ids = blasts.map(&:id)
      expect(response_ids).to eq(db_ids)
    end
  end

  describe 'POST Create' do
    let(:attrs) { attributes_for :blast }
    subject { post :create, blast: attrs, format: :json }

    it 'returns success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns created blast' do
      subject
      parsed_response = parse_response response
      db_blast = user.blasts.first
      expect(parsed_response['id']).to eq(db_blast.id)
      expect(parsed_response['text']).to eq(db_blast.text)
    end

    it 'saves blast text in user' do
      subject
      user.reload
      db_blast = user.blasts.first
      expect(user.last_blast).to eq(db_blast.text)
    end
  end

  describe 'PUT Update' do
    let(:attrs)  { attributes_for :blast }
    let!(:blast) { create :blast, user: user }
    subject { put :update, id: blast.id, blast: attrs, format: :json }

    it 'returns success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns updated blast' do
      subject
      parsed_response = parse_response response
      db_blast = user.blasts.find(blast.id)
      expect(parsed_response['id']).to eq(db_blast.id)
      expect(parsed_response['text']).to eq(db_blast.text)
    end
  end
end

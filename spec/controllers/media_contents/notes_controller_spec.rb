# encoding: utf-8
require 'spec_helper'

describe Api::V1::MediaContents::NotesController do
  render_views
  let!(:user)          { create :user }
  let!(:media_content) { create :media_content, user: user }
  let!(:note)          { create :note, media_content: media_content, user: user }
  let!(:user_b)        { create :user }
  before(:each)        { sign_in user }

  describe 'GET Index' do
    let!(:notes) { create_list :note, 5, media_content: media_content }
    let!(:featured_notes) { create_list :note, 5, is_feature: true, media_content: media_content }

    it 'returns success' do
      get :index, media_content_id: media_content.id, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns list of notes' do
      get :index, media_content_id: media_content.id, format: :json
      resp = parse_response response
      response_ids = resp['notes'].map{ |n| n['id'] }
      notes_ids = media_content.notes.non_featured.pluck(:id)
      expect(response_ids).to match_array(notes_ids)
    end

    it 'returns only featured notes' do
      get :index, media_content_id: media_content.id, format: :json
      resp = parse_response response
      response_featured_ids = resp['featured_notes'].map{ |n| n['id'] }
      featured_notes = media_content.notes.featured.pluck(:id)
      expect(response_featured_ids).to match_array(featured_notes)
    end

    it 'returns right attributes' do
      get :index, media_content_id: media_content.id, format: :json
      resp = parse_response response
      expect(resp['notes'].first.keys).to contain_exactly('id', 'image', 'author', 'thumbnail', 'greenlit', 'greenlights_count')
      expect(resp['notes'].first['author'].keys).to contain_exactly('id', 'username', 'picture')
      expect(resp['media_content'].keys).to contain_exactly('id', 'name')
    end
  end

  describe 'PUT Update' do
    let(:notes) do
      {
        note.id => {
          order: 2,
          is_feature: true
        }
      }
    end
    context 'note belongs to user' do
      it 'returns no content' do
        put :update, media_content_id: media_content.id, notes: notes, format: 'json'
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'note does not belong to user' do
      before(:each)  { sign_in user_b  }

      it 'returns forbidden' do
        put :update, media_content_id: media_content.id, notes: notes, format: 'json'
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST Create' do
    it 'returns success' do
      post :create, media_content_id: media_content.id, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns created note' do
      post :create, media_content_id: media_content.id, format: :json
      resp = parse_response response
      db_note = media_content.notes.last
      expect(resp['id']).to eq(db_note.id)
    end
  end
end

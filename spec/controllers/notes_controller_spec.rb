# encoding: utf-8
require 'spec_helper'

describe Api::V1::NotesController do
  render_views
  let!(:user)          { create :user }
  let!(:note)          { create :note }

  describe 'POST Greenlight' do
    before(:each)  { sign_in user }

    it 'returns success' do
      post :greenlight, id: note.id, format: 'json'
      expect(response).to have_http_status(:no_content)
    end
  end
end

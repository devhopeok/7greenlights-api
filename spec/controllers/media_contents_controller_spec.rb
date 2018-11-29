# encoding: utf-8

require 'spec_helper'

describe Api::V1::MediaContentsController do
  render_views
  let(:media_content) { create :media_content }
  subject(:user) { create :user }
  before(:each) { sign_in user }

  describe 'POST Greenlight' do
    it 'returns success' do
      post :greenlight, id: media_content.id, format: 'json'
      expect(response).to have_http_status(:no_content)
    end

    it 'greenlight an arena' do
      expect {
        post :greenlight, id: media_content.id, format: 'json'
      }.to change {
        user.greenlights.count
      }.from(0).to(1)
      greenlight = user.greenlights.first
      greenlight_content = greenlight.greenlighteable
      expect(greenlight_content.id).to eq(media_content.id)
    end

    context 'arena already greenlit' do
      let!(:greenlight) { create :greenlight, :with_media_content, user: user, greenlighteable: media_content }

      it 'ungreenlit arena' do
        expect {
          post :greenlight, id: media_content.id, format: 'json'
        }.to change {
          user.greenlights.count
        }.from(1).to(0)
        expect(Greenlight.find_by(id: greenlight.id)).to be_nil
      end
    end
  end

  describe 'POST report' do
    let(:attrs) { { message: Faker::Lorem.sentence } }

    it do
      post :report, id: media_content.id, report: attrs, format: :json
      expect(response).to have_http_status(:no_content)
    end

    it 'creates a report for the media content' do
      post :report, id: media_content.id, report: attrs, format: :json
      report = media_content.reports.first
      expect(report).to_not be_nil
      expect(report.user.id).to eq(user.id)
      expect(report.message).to eq(attrs[:message])
    end
  end
end

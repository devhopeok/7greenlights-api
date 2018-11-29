# encoding: utf-8

require 'spec_helper'

describe Api::V1::Me::NotificationsController do
  render_views
  let!(:user)          { create :user }
  let!(:notifications) do
    type = %i(note_uploaded note_featured note_greenlit media_content_greenlit user_greenlit)
    (1..10).each { create type.sample, receiver: user}
  end
  before(:each)        { sign_in user }

  describe 'GET Index' do
    it do
      get :index, format: :json
      resp = parse_response response
      response_ids = resp['notifications'].map{ |n| n['data']['id'] }
      notifications_ids = user.notifications.pluck(:id)
      expect(response_ids).to match_array(notifications_ids)
    end
  end
end

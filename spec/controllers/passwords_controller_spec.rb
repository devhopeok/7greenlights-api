# encoding: utf-8

require 'spec_helper'

describe Api::V1::PasswordsController do
  let!(:user)          { create(:user, password: Faker::Internet.password(10)) }
  let(:password_token) { user.send(:set_reset_password_token) }

  before :each do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    Delayed::Worker.delay_jobs = false
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  context 'with valid params' do
    let(:new_password) { Faker::Internet.password(10) }

    it 'returns a successful response' do
      post :create, user: { email: user.email }, format: 'json'

      expect(response.response_code).to be(204)
    end

    it 'sends an email' do
      expect { post :create, user: { email: user.email }, format: 'json' }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    # reset_password_token is harcoded to match the encryption of the one stored on the db
    it 'returns a successful response' do
      put :update,
          user: {
            password: new_password,
            password_confirmation: new_password,
            reset_password_token: password_token
          },
          format: 'json'

      expect(response.response_code).to be(204)
    end
  end

  context 'with invalid params' do
    it 'does not return a successful response' do
      post :create, user: { email: Faker::Internet.email }, format: 'json'

      expect(response.status).to eq(400)
    end

    it 'does not send an email' do
      expect { post :create, user: { email: Faker::Internet.email }, format: 'json' }
        .to change { ActionMailer::Base.deliveries.count }.by(0)
    end

    # reset_password_token is harcoded to match the encryption of the one stored on the db
    it 'does not change the password if confirmation does not match' do
      put :update,
          user: {
            password: Faker::Internet.password(10),
            password_confirmation: Faker::Internet.password(9),
            reset_password_token: Faker::Crypto.md5
          },
          format: 'json'

      expect(response.status).to eq(400)
    end

    it 'does not change the password if token is invalid' do
      password = Faker::Internet.password(9)
      put :update,
          user: {
            password: password,
            password_confirmation: password,
            reset_password_token: 'not valid token'
          },
          format: 'json'

      expect(response.status).to eq(400)
    end
  end
end

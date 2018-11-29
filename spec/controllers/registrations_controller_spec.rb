# encoding: utf-8

require 'spec_helper'

describe Api::V1::RegistrationsController do
  render_views

  let!(:user) { create(:user) }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "POST 'users/'" do
    let(:username) { Faker::Internet.user_name }
    let(:email)    { Faker::Internet.email }
    let(:password) { Faker::Internet.password(8) }
    let(:user)     { attributes_for :user }

    it 'returns a successful response' do
      post :create, user: user.merge(password_confirmation: user[:password]), format: 'json'

      expect(response.status).to eq(200)
    end

    context 'when there is an error' do
      it 'does not return a successful response' do
        post :create, user: user.merge(email: 'invalid'), format: 'json'

        expect(response.response_code).to eq(400)
      end
    end


    context 'registration with facebook' do
      let(:access_token) { Faker::Crypto.md5 }
      let(:attrs) do {
          username: Faker::Internet.user_name,
          email: Faker::Internet.email,
          access_token: access_token,
          type: 'facebook'
        }
      end
      let(:user) { build(:user, :with_fb) }

      context 'with valid access token' do
        it 'returns success' do
          expect(FacebookClient).to receive(:get_profile)
                                      .and_return(user)
          post :create, user: attrs, format: 'json'
          expect(response.status).to eq(200)
        end
      end

      context 'with invalid access token' do
        it 'returns bad request' do
          expect(FacebookClient).to receive(:get_profile)
                                      .and_return(nil)
          post :create, user: attrs, format: 'json'
          expect(response.status).to eq(400)
        end
      end
    end

    context 'registration with instagram' do
      let(:access_token) { Faker::Crypto.md5 }
      let(:attrs) do {
          username: Faker::Internet.user_name,
          email: Faker::Internet.email,
          access_token: access_token,
          type: 'instagram'
        }
      end

      let(:user) { build(:user ,:with_instagram) }

      context 'with valid access token' do
        it 'returns success' do
          expect(InstagramClient).to receive(:get_profile)
                                      .and_return(user)
          post :create, user: attrs, format: 'json'
          expect(response.status).to eq(200)
        end
      end

      context 'with invalid access token' do
        it 'returns bad request' do
          expect(InstagramClient).to receive(:get_profile)
                                      .and_return(nil)
          post :create, user: attrs, format: 'json'
          expect(response.status).to eq(400)
        end
      end
    end
  end
end

# encoding: utf-8

require 'spec_helper'

describe Api::V1::SessionsController do
  render_views

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'create' do
    let(:password) { 'mypass123' }
    let!(:user)    { create :user, password: password }
    let(:email)    { user.email }
    let(:params)   { { email: email, password: password } }

    context 'with valid login' do
      it 'returns the user json' do
        post :create, user: params, format: 'json'
        expect(parse_response(response)['token']).to_not be_nil
      end
    end

    context 'with invalid login' do
      it 'returns an error' do
        post :create, user: {}, format: 'json'
        expect(parse_response(response)['error']).to eq('authentication error')
      end
    end
  end

  describe "POST 'facebook'" do
    let(:fb_access_token )  { '1234567890_VALID'}
    let!(:user)             { create(:user, :with_fb) }
    let(:user_profile)      { build :user, :with_fb }
    let(:options) do
      {
        access_token: fb_access_token,
        scope: :user
      }
    end

    context 'with valid params' do
      context 'when the user does not exist' do
        it 'returns 200' do
          expect(FacebookClient).to receive(:authenticate)
                                      .with(options)
                                      .and_return(user_profile)

          post :facebook, access_token: fb_access_token, format: 'json'
          expect(response.response_code).to eq(200)
        end

        it 'returns user information' do
          expect(FacebookClient).to receive(:authenticate)
                                      .with(options)
                                      .and_return(user_profile)

          post :facebook, access_token: fb_access_token, format: 'json'
          expect(parse_response(response)['email']).to eq(user_profile.email)
          expect(parse_response(response)['username']).to eq(user_profile.username)
        end
      end

      context 'when the user exists' do
        it 'sign in the user' do
          expect(FacebookClient).to receive(:authenticate)
                                      .with(options)
                                      .and_return(user)
          post :facebook, access_token: fb_access_token, format: :json
          expect(parse_response(response)['token']).to be_truthy
        end
      end
    end

    context 'when the authentication is invalid'  do
      it 'rais 400 error' do
        expect(FacebookClient).to receive(:authenticate)
                                    .with(options)
                                    .and_return(nil)

        post :facebook, access_token: fb_access_token, format: 'json'
        expect(response.status).to eq(400)
      end
    end
  end
end

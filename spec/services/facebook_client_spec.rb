require 'spec_helper'

describe FacebookClient do
  let(:access_token) { Faker::Crypto.md5 }
  let(:user_attr) { attributes_for :user, :with_fb}
  let(:user) { build :user, user_attr }
  let(:db_user) { create :user, user_attr }
  let(:options) do
    {
      scope: :user,
      access_token: access_token
    }
  end

  describe 'authenticate' do
    context 'user not signed up' do
      it 'returns user instance not saved in db' do
        expect(FacebookClient).to receive(:get_profile)
                                    .with(options)
                                    .and_return(user)
        value = FacebookClient.authenticate(options)
        expect(value).to be(user)
        expect(value.persisted?).to be(false)
      end
    end

    context 'user signed up' do
      it 'returns user instance saved in db' do
        expect(FacebookClient).to receive(:get_profile)
                                    .with(options)
                                    .and_return(db_user)
        value = FacebookClient.authenticate(options)
        expect(value).to eq(db_user)
        expect(value.persisted?).to be(true)
      end
    end
  end

  describe 'get_profile' do
    context 'valid access_token' do
      it 'returns a user class' do
        obj = double
        allow(obj).to receive(:get_object)
                                    .and_return(user_attr)
        expect(Koala::Facebook::API).to receive(:new)
                                    .with(access_token)
                                    .and_return(obj)

       value = FacebookClient.get_profile(options)
       expect(value).to be_an_instance_of(User)
      end
    end

    context 'invalid access_token' do
      it 'returns nil' do
        expect(Koala::Facebook::API).to receive(:new)
                                    .and_raise(Koala::KoalaError)

        value = FacebookClient.get_profile(options)
        expect(value).to be_falsy
      end
    end
  end
end

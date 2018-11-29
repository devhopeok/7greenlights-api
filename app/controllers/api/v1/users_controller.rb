# encoding: utf-8

module Api
  module V1
    class UsersController < Api::V1::ApiController
      include Concerns::Greenlighteable

      skip_before_filter :ensure_authenticated_user!, only: [:show]

      helper_method :user

      def show
      end

      private

      def user
        @user ||= User.find(params[:id])
      end
    end
  end
end

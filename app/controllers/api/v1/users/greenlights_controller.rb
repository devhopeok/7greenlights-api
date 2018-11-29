# encoding: utf-8

module Api
  module V1
    module Users
      class GreenlightsController < Api::V1::ApiController
        helper_method :greenlit_users

        skip_before_filter :ensure_authenticated_user!, only: [:users]

        def users
        end

        private

        def user
          @user ||= User.find_by(id: params[:id])
        end

        def greenlit_users
          user.greenlit_users.page(current_page).per(per_page)
        end
      end
    end
  end
end

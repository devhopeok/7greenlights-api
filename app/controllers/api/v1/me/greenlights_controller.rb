# encoding: utf-8

module Api
  module V1
    module Me
      class GreenlightsController < Api::V1::ApiController
        helper_method :greenlit_users

        def users
        end

        private

        def greenlit_users
          @users ||= current_user.greenlit_users.page(current_page).per(per_page)
        end
      end
    end
  end
end

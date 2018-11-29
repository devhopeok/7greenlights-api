module Api
  module V1
    module Users
      class BlastsController < Api::V1::ApiController
        def index
          @blasts = user.blasts.page(current_page).per(per_page)
        end

        private

        def user
          @user ||= User.find(params[:user_id])
        end
      end
    end
  end
end

module Api
  module V1
    module Me
      class BlastsController < Api::V1::ApiController
        helper_method :blast

        def index
          @blasts = blasts.page(current_page).per(per_page)
        end

        def create
          @blast = blasts.create!(text: params[:blast][:text])
        end

        def update
          blast.update!(text: params[:blast][:text])
        end

        private

        def blasts
          current_user.blasts
        end

        def blast
          @blast ||= current_user.blasts.find(params[:id])
        end
      end
    end
  end
end

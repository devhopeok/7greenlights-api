# encoding: utf-8
module Api
  module V1
    class MeController < Api::V1::ApiController
      def show
      end

      def update
        current_user.update!(profile_params)
      end

      private

      def profile_params
        params.require(:user).permit(
          :username, :picture, :about, :goals,
          tooltips: User.custom_tooltips,
          social_media_links: [:type, :url]
        )
      end
    end
  end
end

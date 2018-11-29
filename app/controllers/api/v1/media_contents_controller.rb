# encoding: utf-8

module Api
  module V1
    class MediaContentsController < Api::V1::ApiController
      include Concerns::Greenlighteable

      helper_method :media_content

      def report
        media_content.reports.create!(
          message: params[:report][:message],
          user: current_user
        )
        head :no_content
      end

      private

      def media_content
        @media_content ||= MediaContent.find(params[:id])
      end
    end
  end
end

# encoding: utf-8
# :reek:FeatureEnvy
module Api
  module V1
    class ArenasController < Api::V1::ApiController
      include Concerns::Greenlighteable

      skip_before_filter :ensure_authenticated_user!, only: [:index, :show]
      helper_method :arena

      def index
        @arenas = Arena
                  .filtered(filter_params)
                  .sorted(sort_params)
                  .page(current_page).per(per_page)
      end

      def show
      end

      private

      def filter_params
        {
          filter_types: params[:filters].try(:map, &:to_i),
          user: current_user
        }
      end

      def sort_params
        {
          sort_type: params[:sort].try(:to_i),
          order_type: params[:order].try(:to_i)
        }
      end

      def arena
        @arena ||= Arena.find(params[:id])
      end
    end
  end
end

module Api
  module V1
    module Concerns
      module Paginable
        extend ActiveSupport::Concern
        included do
          helper_method :current_page, :per_page
        end

        def current_page
          @current_page ||= params[:page]
        end

        def per_page
          @per_page ||= params[:per_page]
        end
      end
    end
  end
end

module Api
  module V1
    module Arenas
      class MediaContentsController < Api::V1::ApiController
        include Concerns::MediaContents::Filterable
        include Concerns::MediaContents::Sortable

        skip_before_filter :ensure_authenticated_user!, only: [:index]

        def index
          @media_contents = arena
                            .media_contents
                            .with_featured_notes
                            .not_reported(include_user: current_user)
                            .filtered(filter_params)
                            .sorted(sort_params)
                            .page(current_page)
                            .per(per_page)
        end

        private

        def arena
          @arena ||= Arena.find(params[:arena_id])
        end

        def set_sort_context
          'arena'
        end
      end
    end
  end
end

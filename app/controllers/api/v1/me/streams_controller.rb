module Api
  module V1
    module Me
      class StreamsController < Api::V1::ApiController
        include Concerns::MediaContents::Filterable
        include Concerns::MediaContents::Sortable

        def index
          @stream = stream_items
                    .with_featured_notes
                    .filtered(filter_params)
                    .sorted(sort_params)
                    .page(current_page).per(per_page)
          @arenas = stream_items.arenas_id_name
        end

        private

        def set_sort_context
          'stream'
        end

        def stream_items
          current_user.stream_items
        end
      end
    end
  end
end

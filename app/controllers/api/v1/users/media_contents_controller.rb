module Api
  module V1
    module Users
      class MediaContentsController < Api::V1::ApiController
        include Concerns::MediaContents::Filterable
        include Concerns::MediaContents::Sortable

        skip_before_filter :ensure_authenticated_user!, only: [:index]

        def index
          @media_contents = requested_media_content
          @media_content = media_content_from_notification
        end

        private

        def media_contents
          user.media_contents
        end

        def media_content_from_notification
          media_contents
            .find_by(id: params[:media_content_id])
            .tap { |media| media && media.reported? ? nil : media }
        end

        def requested_media_content
          media_contents
            .not_reported
            .with_featured_notes
            .filtered(filter_params)
            .sorted(sort_params)
            .page(current_page).per(per_page)
        end

        def user
          @user ||= User.find(params[:user_id])
        end

        def set_sort_context
          'media'
        end
      end
    end
  end
end

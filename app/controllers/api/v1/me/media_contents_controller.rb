module Api
  module V1
    module Me
      class MediaContentsController < Api::V1::ApiController
        include Concerns::MediaContents::Filterable
        include Concerns::MediaContents::Sortable

        helper_method :media_content

        def index
          @media_contents = requested_media_content
          @media_content = media_contents.find_by(id: params[:media_content_id])
        end

        def create
          @media_content = media_contents.create!(media_content_create_params)
        end

        def update
          media_content.update!(media_content_update_params)
        end

        def destroy
          media_content.destroy!
          head :no_content
        end

        private

        def requested_media_content
          media_contents
            .with_featured_notes
            .filtered(filter_params)
            .sorted(sort_params)
            .page(current_page).per(per_page)
        end

        def media_contents
          current_user.media_contents
        end

        def media_content
          @media_content ||= current_user.media_contents.find(params[:id])
        end

        def media_content_create_params
          params.require(:media_content).permit(
            :name, :media_url, :content_type, :remote_image_url, links: [:type, :url]
          )
        end

        def media_content_update_params
          params.require(:media_content).permit(
            :name, :content_type, :remote_image_url, links: [:type, :url]
          )
        end

        def set_sort_context
          'media'
        end
      end
    end
  end
end

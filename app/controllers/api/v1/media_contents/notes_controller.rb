module Api
  module V1
    module MediaContents
      class NotesController < Api::V1::ApiController
        helper_method :media_content

        def index
          @notes = notes
                   .non_featured
                   .order(id: :desc)
                   .page(current_page)
                   .per(per_page)
          @featured_notes = notes.featured.order(order: :asc)
        end

        def create
          @note = notes.create!(
            user: current_user,
            image: params[:image]
          )
        end

        def update
          if user_allowed?
            Note.update(note_ids, note_params)
            head :no_content
          else
            head :forbidden
          end
        end

        private

        def notes
          media_content.notes
        end

        def media_content
          @media_content ||= MediaContent.find(params[:media_content_id])
        end

        def user_allowed?
          current_user.media_contents.exists?(media_content.id)
        end

        def note_ids
          params[:notes].keys
        end

        def note_params
          ActionController::Parameters.new(
            data: params[:notes].values
          ).permit(data: [:is_feature, :order])[:data]
        end
      end
    end
  end
end

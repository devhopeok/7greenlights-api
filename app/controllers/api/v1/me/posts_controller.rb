# encoding: utf-8

module Api
  module V1
    module Me
      class PostsController < Api::V1::ApiController
        def create
          return render_bad_request if invalid_number_of_records
          Post.create_batch!(post_params)
          head :no_content
        end

        private

        def render_bad_request
          render json: { error: 'You can only create 30 posts or less.' }, status: :bad_request
        end

        def invalid_number_of_records
          source = params[:arenas_ids] || params[:media_contents_ids]
          source.nil? || source.count >= 30
        end

        def post_params
          params.permit(
            :media_content_id, :arena_id,
            media_contents_ids: [], arenas_ids: []
          ).merge(user_id: current_user.id)
        end
      end
    end
  end
end

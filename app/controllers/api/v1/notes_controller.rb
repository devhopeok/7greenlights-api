module Api
  module V1
    class NotesController < Api::V1::ApiController
      include Concerns::Greenlighteable

      private

      def note
        @note ||= Note.find(params[:id])
      end
    end
  end
end

module Api
  module V1
    module Concerns
      module Greenlighteable
        extend ActiveSupport::Concern

        def greenlight
          current_user.toggle_greenlight(greenlighteable_object)
          head :no_content
        end

        private

        def model_name
          controller_name.demodulize.sub('Controller', '').underscore.singularize
        end

        def greenlighteable_object
          send(model_name)
        end
      end
    end
  end
end

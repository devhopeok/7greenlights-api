module Api
  module V1
    module Concerns
      module MediaContents
        module Filterable
          extend ActiveSupport::Concern

          def filter_params
            {
              filter_types: params[:filters].try(:map, &:to_i),
              arenas_ids: params[:arenas_ids].try(:map, &:to_i),
              user: current_user,
              population_types: params[:pop_types].try(:map, &:to_i),
              content_types: params[:content_types].try(:map, &:to_i)
            }
          end
        end
      end
    end
  end
end

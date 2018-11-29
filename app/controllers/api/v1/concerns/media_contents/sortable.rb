module Api
  module V1
    module Concerns
      module MediaContents
        module Sortable
          extend ActiveSupport::Concern

          def sort_params
            {
              sort_type: params[:sort].try(:to_i),
              order_type: params[:order].try(:to_i),
              context: set_sort_context
            }
          end
        end
      end
    end
  end
end

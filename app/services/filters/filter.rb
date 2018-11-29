module Filters
  class Filter
    def initialize(scope, params)
      @filter_params = params
      @filtered_set = scope
    end

    def run_filter
      filter_types = @filter_params[:filter_types]
      if filter_types.present?
        filter_types.each do |type|
          filter_type = self.class::FILTER_TYPES[type]
          @filtered_set = send(filter_type) if filter_type
        end
      end
      @filtered_set
    end
  end
end

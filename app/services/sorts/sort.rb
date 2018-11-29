module Sorts
  class Sort
    ORDER_TYPES = {
      0 => :asc,
      1 => :desc
    }

    def initialize(scope, params)
      @context = params[:context]
      @order_type = order_types(params[:order_type]) || order_types(0)
      @sort_type = sort_types(params[:sort_type]) || sort_types(0)
      @sorted_set = scope
    end

    def run_sort
      send(@sort_type)
    end

    private

    def order_types(param)
      self.class::ORDER_TYPES[param]
    end

    def sort_types(param)
      self.class::SORT_TYPES[param]
    end
  end
end

module Sorts
  class ArenaSort < Sorts::Sort
    SORT_TYPES = {
      0 => :time_remaining,
      1 => :total_greenlight,
      2 => :alphabetically,
      3 => :created_at
    }

    private

    def time_remaining
      @sorted_set.order(end_date: @order_type)
    end

    def total_greenlight
      @sorted_set.order(greenlights_count: @order_type)
    end

    def alphabetically
      @sorted_set.order(name: @order_type)
    end

    def created_at
      @sorted_set.order(created_at: @order_type)
    end
  end
end

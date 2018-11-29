module Sorts
  class MediaContentSort < Sorts::Sort
    SORT_TYPES = {
      0 => :creator,
      1 => :total_greenlight,
      2 => :alphabetically,
      3 => :added_date
    }

    private

    def added_date
      filter_type = "date_added_to_#{@context}".to_sym
      @sorted_set = send(filter_type) if private_methods.include?(filter_type)
      @sorted_set
    end

    def creator
      @sorted_set.order(username: @order_type)
    end

    def total_greenlight
      @sorted_set.order(greenlights_count: @order_type)
    end

    def alphabetically
      @sorted_set.order(name: @order_type)
    end

    def date_added_to_media
      @sorted_set.order(id: @order_type)
    end

    def date_added_to_arena
      @sorted_set.order("posts.id #{@order_type.upcase}")
    end

    def date_added_to_stream
      @sorted_set.order("greenlights.id #{@order_type.upcase}")
    end
  end
end

module Filters
  class MediaContentFilter < Filters::Filter
    FILTER_TYPES = {
      0 => :by_arena,
      1 => :by_content_type,
      2 => :by_population
    }

    private

    def by_arena
      arenas_ids = @filter_params[:arenas_ids] || (return @filtered_set)
      @filtered_set.joins(:posts).where('posts.arena_id IN (?)', arenas_ids)
    end

    def by_content_type
      content_types = @filter_params[:content_types] || (return @filtered_set)
      @filtered_set.where(content_type: content_types)
    end

    def by_population
      user = @filter_params[:user] || (return @filtered_set)
      population_types = @filter_params[:population_types]
      MediaContentByPopulation.new(@filtered_set, user, population_types).run_filter
    end
  end
end

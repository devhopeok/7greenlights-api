module Filters
  class ArenaFilter < Filters::Filter
    FILTER_TYPES = {
      0 => :active,
      1 => :greenlit_by_user,
      2 => :archived,
      3 => :feature,
      4 => :non_feature,
      5 => :posted_arenas
    }

    private

    def feature
      @filtered_set.where(is_feature: true)
    end

    def non_feature
      @filtered_set.where(is_feature: false)
    end

    def active
      @filtered_set.where('end_date >= ?', DateTime.now)
    end

    def archived
      @filtered_set.where('end_date < ?', DateTime.now)
    end

    def greenlit_by_user
      user = @filter_params[:user]
      return @filtered_set unless user
      user.greenlit_arenas
    end

    def posted_arenas
      user = @filter_params[:user]
      return Arena.none  unless user
      user.posted_arenas.select('DISTINCT arenas.id, arenas.*')
    end
  end
end

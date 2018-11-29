module Filters
  class MediaContentByPopulation
    def initialize(scope, user, population_types)
      @user = user
      @population_types = population_types.map { |type| Constants::POPULATION_TYPES[type] }
      @filtered_set = scope
    end

    def run_filter
      pops_query = 'media_contents.user_id IN (:users)' if all_except_stranger?
      strangers_query = 'media_contents.user_id NOT IN (:all_users)' if stranger?
      query =  [pops_query, strangers_query].compact.join(' OR ')
      @filtered_set.where(
        query,
        users: @user.pops_user_ids(@population_types),
        all_users: @user.pops_user_ids(Constants::POPULATION_TYPES.values)
      )
    end

    private

    def stranger?
      @population_types.include?(:strangers)
    end

    def all_except_stranger?
      @population_types.any? { |type| type != :strange }
    end
  end
end

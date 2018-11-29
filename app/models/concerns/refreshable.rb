# encoding: utf-8
module Refreshable
  extend ActiveSupport::Concern

  module ClassMethods
    def refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: false)
    end
  end
end

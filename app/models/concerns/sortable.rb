# encoding: utf-8

module Sortable
  extend ActiveSupport::Concern
  class_methods do
    def sorted(params)
      "Sorts::#{self}Sort".constantize.new(all, params).run_sort
    end
  end
end

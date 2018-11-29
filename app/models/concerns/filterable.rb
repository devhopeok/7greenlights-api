# encoding: utf-8

module Filterable
  extend ActiveSupport::Concern
  class_methods do
    def filtered(params)
      "Filters::#{self}Filter".constantize.new(all, params).run_filter
    end
  end
end

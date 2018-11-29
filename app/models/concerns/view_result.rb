# encoding: utf-8
module ViewResult
  extend ActiveSupport::Concern

  included do
    belongs_to :searchable, polymorphic: true

    private

    def readonly?
      true
    end
  end
end

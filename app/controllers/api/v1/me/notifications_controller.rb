# encoding: utf-8
module Api
  module V1
    module Me
      class NotificationsController < Api::V1::ApiController
        def index
          @notifications = current_user
                           .notifications
                           .order(created_at: :desc)
                           .page(current_page).per(per_page)
        end
      end
    end
  end
end

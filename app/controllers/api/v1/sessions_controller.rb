# encoding: utf-8

module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_filter :verify_authenticity_token, if: :json_request?

      # POST /resource/sign_in
      def create
        @resource = warden.authenticate! scope: resource_name, recall: "#{controller_path}#failure"
        return failure unless @resource
        sign_in_and_redirect
      end

      def facebook
        @resource = FacebookClient.authenticate scope: resource_name, access_token: params[:access_token]
        return failure unless @resource
        sign_in_and_redirect if @resource.persisted?
      end

      def instagram
        @resource = InstagramClient.authenticate scope: resource_name, access_token: params[:access_token]
        return failure unless @resource
        sign_in_and_redirect if @resource.persisted?
      end

      def sign_in_and_redirect
        sign_in(resource_name, @resource)
        render 'devise/sessions/create'
      end

      # DELETE /resource/sign_out
      def destroy
        # expire auth token
        current_user.invalidate_token
        reset_session
        head :no_content
      end

      def failure
        render json: { errors: ['Login failed.'] }, status: :bad_request
      end

      protected

      def json_request?
        request.format.json?
      end
    end
  end
end

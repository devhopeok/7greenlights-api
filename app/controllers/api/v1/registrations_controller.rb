# encoding: utf-8

module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      before_action :configure_permitted_parameters, only: [:create]
      skip_before_filter :verify_authenticity_token, if: :json_request?

      def create
        sign_up_params = registration_strategy_params
        return auth_error unless sign_up_params
        build_resource(sign_up_params)
        return sign_up_error unless resource.save
        save_success
      end

      private

      def auth_error
        render json: { error: 'Social Media authentication error.' }, status: :bad_request
      end

      def sign_up_error
        render json: { error: resource.errors }, status: :bad_request
      end

      def registration_strategy_params
        user = params[:user]
        options = {
          access_token: user[:access_token],
          scope: resource_name
        }
        social_params =
        case user[:type]
        when 'facebook'
          user_ret = FacebookClient.get_profile(options)
          { facebook_id: user_ret.try(:facebook_id) }
        when 'instagram'
          user_ret = InstagramClient.get_profile(options)
          { instagram_id: user_ret.try(:instagram_id) }
        else
          return sign_up_params
        end
        user_ret ? sign_up_params.merge(social_params) : nil
      end

      protected

      def save_success
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
        else
          expire_data_after_sign_in!
        end
        @resource = resource
      end

      def configure_permitted_parameters
        devise_parameter_sanitizer.for :sign_up do |params|
          params.permit(
            :email, :username,
            :password, :password_confirmation,
            :birthday
          )
        end
      end

      def json_request?
        request.format.json?
      end

      def require_no_authentication
        assert_is_devise_resource!
        return unless is_navigational_format?
        no_input = devise_mapping.no_input_strategies

        authenticated =
          if no_input.present?
            args = no_input.dup.push scope: resource_name
            warden.authenticate?(*args)
          else
            warden.authenticated?(resource_name)
          end
        resource = warden.user(resource_name)
        return unless authenticated && resource
        message = I18n.t('devise.failure.already_authenticated')
        flash[:alert] = message
        render json: { message: message }
      end
    end
  end
end

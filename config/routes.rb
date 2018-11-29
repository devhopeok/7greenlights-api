# encoding: utf-8

Railsroot::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, path:'api/v1/users', module: 'api/v1'
#             jcropper_admin_venue PUT        /admin/venues/:id/jcropper(.:format)                            admin/venues#jcropper


  namespace :admin do
    resources :arenas, only: [] do
      put :jcropper, to: 'venues#jcropper', on: :member, as: :jcropper
    end
  end
  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      get :status, to: 'api#status'
      devise_scope :user do
        resources :users, only: [:show] do
          resources :media_contents, only: [:index], module: :users
          resources :blasts, only: [:index], module: :users
          post :greenlight, on: :member
          get 'greenlights/users', to: 'users/greenlights#users', on: :member
          collection do
            post :facebook, to:'sessions#facebook'
            post :instagram, to:'sessions#instagram'
          end
        end
      end
      resources :me, only: [] do
        collection do
          get :show
          put :update
          get 'greenlights/users', to: 'me/greenlights#users'
          resources :media_contents, except: [:new, :edit, :show], module: :me
          resources :notifications, only: [:index], module: :me
          resources :streams, only: [:index], module: :me
          resources :posts, only: [:create], module: :me
          resources :blasts, only: [:create, :update, :index], module: :me
        end
      end
      resources :media_contents, only: [] do
        post :greenlight, on: :member
        post :report, on: :member
        put 'notes/update', to: 'media_contents/notes#update'
        resources :notes, module: :media_contents, only: [:index, :create]
      end
      resources :arenas, only: [:show, :index] do
        post :greenlight, on: :member
        resources :media_contents, only: [:index], module: :arenas
      end
      resources :notes, only: [] do
        post :greenlight, on: :member
      end
    end
  end
end

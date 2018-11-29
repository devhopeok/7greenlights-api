json.users    greenlit_users, partial: 'api/v1/shared/users/info', as: :user
json.partial! 'api/v1/shared/paginated', items: greenlit_users

json.blasts   blasts, partial: 'api/v1/shared/blasts/info', as: :blast
json.partial! 'api/v1/shared/paginated', items: blasts

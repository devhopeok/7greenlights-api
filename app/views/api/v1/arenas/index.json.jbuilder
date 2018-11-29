json.arenas   @arenas, partial: 'api/v1/arenas/info', as: :arena
json.partial! 'api/v1/shared/paginated', items: @arenas

json.stream   @stream, partial: 'api/v1/shared/media_contents/info', as: :media_content
json.partial! 'api/v1/shared/paginated', items: @stream
json.arenas(@arenas) do |arena|
  json.id   arena.id
  json.name arena.name
end

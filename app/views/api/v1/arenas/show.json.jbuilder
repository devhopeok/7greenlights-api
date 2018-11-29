json.partial!                        'api/v1/arenas/info', arena: arena
json.media_content_count              arena.media_contents.count
json.media_contents_greenlights_count arena.media_contents_greenlights_count
json.description                      arena.description
json.image                            arena.image.url
json.sponsors(arena.sponsors) do |sponsor|
  json.id       sponsor.id
  json.picture  sponsor.picture.url(:small)
  json.url      sponsor.url
end

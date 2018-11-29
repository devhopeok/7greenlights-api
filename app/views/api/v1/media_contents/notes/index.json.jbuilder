json.notes          @notes, partial: 'api/v1/shared/notes/info', as: :note
json.featured_notes @featured_notes, partial: 'api/v1/shared/notes/info', as: :note
json.partial! 'api/v1/shared/paginated', items: @notes
json.media_content do
  json.id media_content.id
  json.name media_content.name
end

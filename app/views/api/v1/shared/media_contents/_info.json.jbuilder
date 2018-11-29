json.id                media_content.id
json.name              media_content.name
json.media_url         media_content.media_url
json.image             media_content.image.url(:small)
json.content_type      media_content.content_type
json.links             media_content.links
json.greenlit          current_user.greenlit?(media_content) if current_user
json.greenlights_count media_content.greenlights_count
if media_content.user
  json.author do
    json.partial! 'api/v1/shared/users/info', user: media_content.user
  end
end
json.reported          media_content.reported?
ordered_featured_notes = media_content.featured_notes.sort_by { |r| r[:order] }
json.featured_notes(ordered_featured_notes) do |note|
  json.partial! 'api/v1/shared/notes/info', note: note
end

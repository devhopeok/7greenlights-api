json.id                note.id
json.image             note.image.url
json.thumbnail         note.image.url(:small)
json.greenlit          current_user.greenlit?(note) if current_user
json.greenlights_count note.greenlights_count
if note.user_id
  json.author do
    json.id       note.user.id
    json.username note.user.username
    json.picture  note.user.picture.url(:small)
  end
end

json.id                arena.id
json.name              arena.name
json.blast             arena.blast
json.image_thumbnail   arena.image.url(:medium)
json.end_date          arena.end_date
json.is_feature        arena.is_feature
json.greenlit          current_user.greenlit?(arena) if current_user
json.greenlights_count arena.greenlights_count

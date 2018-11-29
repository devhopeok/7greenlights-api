json.id                   user.try(:id)
json.email                user.email
json.username             user.username
json.birthday             user.birthday || user.birthday_str
json.picture              user.picture.url(:small)
json.last_blast           user.last_blast
json.greenlit             current_user.greenlit?(user) if current_user
json.greenlights_received user.greenlights_count
json.channel              user.channel
json.tooltips             user.tooltips

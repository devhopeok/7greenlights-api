json.notifications(@notifications) do |notification|
  json.(notification, :data)
end
json.partial! 'api/v1/shared/paginated', items: @notifications

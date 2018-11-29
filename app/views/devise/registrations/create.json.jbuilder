json.partial! 'api/v1/shared/users/info', user: @resource
json.partial! 'api/v1/shared/users/profile', user: @resource
json.token    @resource.authentication_token

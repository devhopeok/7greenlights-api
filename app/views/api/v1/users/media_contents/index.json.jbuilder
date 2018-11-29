json.partial! 'api/v1/shared/media_contents/index', media_contents: @media_contents
json.media_requested do
  json.partial! 'api/v1/shared/media_contents/info', media_content: @media_content if @media_content
end

json.media_contents media_contents, partial: 'api/v1/shared/media_contents/info', as: :media_content
json.partial!       'api/v1/shared/paginated', items: media_contents

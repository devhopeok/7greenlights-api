class DomainRedirectionMiddleware
  def initialize(app, api_host, web_host)
    @app = app
    @web_host = web_host
    @api_host = api_host
  end

  def call(env)
    host = env['HTTP_HOST']
    path = env['REQUEST_PATH']

    return redirect_to_main_host(host, path) if require_redirect?(host)

    @status, @headers, @response = @app.call(env)

    [@status, @headers, @response]
  end

  def require_redirect?(host)
    host != @api_host
  end

  def redirect_to_main_host(origin, request_path)
    redirect_url = "https://#{@web_host}#{request_path}"

    RedirectionHit.create!(path: request_path, origin: origin)

    [
      301,
      {
        'Location' => redirect_url,
        'Content-Type' => 'text/html',
        'Content-Length' => '0'
      },
      []
    ]
  end
end

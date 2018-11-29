class InstagramClient < SocialNetwork
  def self.authenticate(options)
    super(options) do |class_name, value|
      class_name.find_by(instagram_id: value.instagram_id)
    end
  end

  def self.client(options)
    Instagram.client(access_token: options[:access_token])
  end

  def self.get_profile(options)
    super { client(options).user }
  end

  def self.create_payload(response, scope)
    super { |resource| resource.instagram_id = response['id'] }
  end
end

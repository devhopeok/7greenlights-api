class FacebookClient < SocialNetwork
  def self.authenticate(options)
    super(options) do |class_name, value|
      class_name.find_by(facebook_id: value.facebook_id)
    end
  end

  def self.client(options)
    Koala::Facebook::API.new(options[:access_token])
  end

  def self.get_profile(options)
    super { client(options).get_object('me?fields=email,birthday') }
  end

  def self.create_payload(response, scope)
    super { |resource| resource.facebook_id = response['id'] }
  end
end

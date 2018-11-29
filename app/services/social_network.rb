class SocialNetwork
  def self.authenticate(options)
    value = get_profile(options)
    return if value.nil?
    class_name = Devise.mappings[options[:scope]].to
    ret = yield class_name, value
    ret || value
  end

  def self.get_profile(options)
    create_payload yield, options[:scope]
  rescue Instagram::Error, Koala::KoalaError => ex
    Rails.logger.info { "#{name} authentication failed #{ex}" }
    nil
  end

  def self.create_payload(response, scope)
    class_name = Devise.mappings[scope].to
    resource = class_name.new(
      username:     response['username'],
      email:        response['email'],
      birthday_str: response['birthday']
    )
    yield resource
    resource
  end
end

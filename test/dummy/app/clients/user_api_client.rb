class UserApiClient
  def self.fetch(user)
    OpenStruct.new(name: 'David', email: 'email@example.com')
  end
end

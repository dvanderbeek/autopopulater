class User < ApplicationRecord
  autopopulates :name
  autopopulates :email, with: ->(user) { 'email@example.com' }

  def fetch_name
    'David'
  end
end

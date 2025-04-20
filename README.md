# Autopopulater
A Rails gem for automatically populating model attributes via remote APIs.

## Usage
How to use my plugin.

### Basic Usage
```ruby
class User < ApplicationRecord
  autopopulates :name, :email, with: ->(user) { UserApiClient.fetch(user) }
end
```

### Test Mode
The gem includes a test mode that makes it easy to bypass external API calls in your tests. You can either stub individual attributes or register test objects for specific model/attribute combinations.

#### Stubbing Individual Attributes
```ruby
class UserTest < ActiveSupport::TestCase
  include Autopopulater::TestHelper

  test "uses test stubs" do
    stub_autopopulater(:name, "Test Name")
    stub_autopopulater(:email, "test@example.com")

    user = User.new
    user.valid?

    assert_equal "Test Name", user.name
    assert_equal "test@example.com", user.email
  end
end
```

#### Using Test Lookups
```ruby
class UserTest < ActiveSupport::TestCase
  include Autopopulater::TestHelper

  setup do
    # Register a test object for specific attributes of the User model
    test_user = OpenStruct.new(name: "Test User", email: "test@example.com")
    register_test_lookup(User, [:name, :email], test_user)
  end

  test "uses test lookup" do
    user = User.new
    user.valid?

    assert_equal "Test User", user.name
    assert_equal "test@example.com", user.email
  end
end
```

The test helper automatically resets the test mode between tests, but you can also manually control it:

```ruby
enable_autopopulater_test_mode  # Enable test mode
disable_autopopulater_test_mode # Disable test mode
clear_autopopulater_stubs       # Clear all test stubs
clear_test_lookups              # Clear all test lookups
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "autopopulater"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install autopopulater
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

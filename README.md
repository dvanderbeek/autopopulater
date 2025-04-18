# Autopopulater

A Rails gem that enables automatic population of model attributes via remote APIs or custom methods.

## Description

Autopopulater provides a simple way to automatically populate your Rails model attributes when a record is created. It supports various ways to fetch the data, including:

- External API calls
- Custom methods
- Lambda functions
- Hash or object responses

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

## Usage

### Basic Usage

The gem provides an `autopopulates` method that you can use in your models to specify which attributes should be automatically populated and how.

```ruby
class User < ApplicationRecord
  autopopulates :name, :email, with: ->(user) { UserApiClient.fetch(user) }
end
```

### Different Ways to Populate Attributes

#### 1. Using a Separate Class

```ruby
autopopulates :name, :email, with: ->(user) { UserApiClient.fetch(user) }
```

#### 2. Using a Lambda that Returns an Object

```ruby
autopopulates :name, :email, with: ->(user) { OpenStruct.new(name: 'David', email: 'email@example.com') }
```

#### 3. Using a Lambda that Returns a Hash

```ruby
autopopulates :name, :email, with: ->(user) { { name: 'David', email: 'email@example.com' } }
```

#### 4. Using a Callable that Returns a Single Value

```ruby
autopopulates :email, with: ->(user) { 'email@example.com' }
```

#### 5. Using a Custom Method

```ruby
autopopulates :name, with: :name_from_api

def name_from_api
  'David'
end
```

#### 6. Using a Method that Matches the Pattern `fetch_#{attr}`

```ruby
autopopulates :name

def fetch_name
  'David'
end
```

### Features

- Automatically populates attributes on record creation
- Supports multiple attributes at once
- Flexible data source options (API, methods, lambdas)
- Skips population if attributes are already set
- Can be disabled per record using `autopopulated: false`
- Supports overwriting existing values with `autopopulate_attributes(overwrite: true)`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dvanderbeek/autopopulater.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

require "test_helper"
require "minitest/mock"

class AutopopulaterTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Autopopulater::VERSION
  end

  test "it works with a fetch_attr method" do
    u = User.new
    u.valid?
    assert_equal u.name, "David"
  end

  test "it works with a callable" do
    u = User.new
    u.valid?
    assert_equal u.email, "email@example.com"
  end

  test "it skips autopopulation if disabled" do
    u = User.new(autopopulated: false)

    u.stub(:autopopulate_attributes, proc { raise "should not be called" }) do
      u.valid?
      assert u.email.nil?
    end
  end

  test "it skips autopopulation if attr is already populated" do
    email = 'custom@email.com'
    u = User.new(email:)
    u.valid?

    assert_equal u.email, email
  end

  test "it allows an attr to be overwritten" do
    u = User.new(email: 'custom@email.com')
    u.autopopulate_attributes(overwrite: true)

    assert_equal u.email, "email@example.com"
  end

  test "it lets you introspect autopopulated attributes" do
    assert_equal User.autopopulated_attributes[0][:keys], [:name, :email]
  end
end

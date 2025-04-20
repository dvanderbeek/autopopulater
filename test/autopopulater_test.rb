require "test_helper"
require "minitest/mock"

class AutopopulaterTest < ActiveSupport::TestCase
  include Autopopulater::TestHelper

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
    assert_equal User.autopopulated_attributes.collect { |e| e[:keys] }.flatten.sort,
                 [:name, :email].sort
  end

  test "it uses test stubs when in test mode" do
    # TODO: Should also specify the model
    # e.g. stub_autopopulater(User, :name, "Test Name")
    stub_autopopulater(:name, "Test Name")
    stub_autopopulater(:email, "test@example.com")

    u = User.new
    u.valid?

    assert_equal u.name, "Test Name"
    assert_equal u.email, "test@example.com"
  end

  test "it uses test lookups when in test mode" do
    test_user = OpenStruct.new(name: "Test User", email: "test@example.com")
    register_test_lookup(User, [:email], test_user)

    u = User.new
    u.valid?

    assert_equal u.email, "test@example.com"
  end

  test "it resets test mode between tests" do
    assert_equal false, Autopopulater.test_mode?
    assert_empty Autopopulater.test_stubs
    assert_empty Autopopulater.test_lookups
  end
end

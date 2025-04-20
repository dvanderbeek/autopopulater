require "autopopulater/version"
require "autopopulater/railtie"
require "autopopulater/autopopulated"
require "autopopulater/test_helper"

module Autopopulater
  class << self
    attr_accessor :test_mode, :test_stubs, :test_lookups

    def configure
      yield self
    end

    def test_mode?
      !!@test_mode
    end

    def test_stub_for(model_class, attribute)
      return nil unless test_mode?
      @test_stubs&.dig(model_class)&.dig(attribute)
    end

    def test_lookup_for(model_class, attributes)
      return nil unless test_mode?
      @test_lookups&.dig(model_class)&.dig(attributes)
    end
  end

  # Initialize defaults
  @test_mode = false
  @test_stubs = {}
  @test_lookups = {}
end

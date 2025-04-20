module Autopopulater
  module TestHelper
    def self.included(base)
      base.class_eval do
        setup :reset_autopopulater_test_mode
        teardown :reset_autopopulater_test_mode
      end
    end

    def enable_autopopulater_test_mode
      Autopopulater.test_mode = true
    end

    def disable_autopopulater_test_mode
      Autopopulater.test_mode = false
    end

    def stub_autopopulater(model_class, attribute, value)
      enable_autopopulater_test_mode
      Autopopulater.test_stubs[model_class] ||= {}
      Autopopulater.test_stubs[model_class][attribute] = value
    end

    def clear_autopopulater_stubs
      Autopopulater.test_stubs.clear
    end

    def register_test_lookup(model_class, attributes, test_object)
      enable_autopopulater_test_mode
      Autopopulater.test_lookups[model_class] ||= {}
      Autopopulater.test_lookups[model_class][attributes] = test_object
    end

    def clear_test_lookups
      Autopopulater.test_lookups.clear
    end

    private

    def reset_autopopulater_test_mode
      Autopopulater.test_mode = false
      Autopopulater.test_stubs.clear
      Autopopulater.test_lookups.clear
    end
  end
end

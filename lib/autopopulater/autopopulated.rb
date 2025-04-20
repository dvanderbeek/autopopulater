module Autopopulater
  module Autopopulated
    extend ActiveSupport::Concern

    included do
      class_attribute :autopopulated_attributes
    end

    class_methods do
      def autopopulates(*attributes, with: nil)
        self.autopopulated_attributes ||= []

        autopopulated_attributes << { keys: attributes, with: with }

        attribute :autopopulated, :boolean, default: true

        before_validation :autopopulate_attributes, on: :create, if: :autopopulated
      end
    end

    def autopopulate_attributes(overwrite: false)
      self.class.autopopulated_attributes.each do |a|
        a[:keys].each do |attr|
          next unless overwrite || send(attr).blank?

          if Autopopulater.test_mode?
            if (stub = Autopopulater.test_stub_for(self.class, attr))
              send("#{attr}=", stub)
            elsif (test_object = Autopopulater.test_lookup_for(self.class, a[:keys]))
              value = fetch_value(->(_) { test_object })
              send("#{attr}=", attr_value(value, attr))
            else
              value = fetch_value(a[:with])
              send("#{attr}=", attr_value(value, attr))
            end
          else
            value = fetch_value(a[:with])
            send("#{attr}=", attr_value(value, attr))
          end
        end
      end
    end

    private

    def fetch_value(method)
      if method.respond_to?(:call)
        method.call(self)
      elsif method.is_a?(Symbol) || method.is_a?(String)
        send(method)
      else
        nil
      end
    end

    def attr_value(value, attr)
      if value && value.respond_to?(attr)
        value.send(attr)
      elsif value && value.is_a?(Hash) && value.key?(attr)
        value.with_indifferent_access[attr]
      elsif value
        value
      else
        send("fetch_#{attr}")
      end
    end
  end
end

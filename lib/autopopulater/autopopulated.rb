module Autopopulater
  module Autopopulated
    extend ActiveSupport::Concern

    included do
      class_attribute :autopopulated_attributes
      attribute :autopopulated, :boolean, default: true
    end

    class_methods do
      def autopopulates(*attributes, with: nil)
        self.autopopulated_attributes ||= {}

        attributes.each do |attr|
          autopopulated_attributes[attr] = with
        end

        before_validation :autopopulate_attributes, on: :create, if: :autopopulated
      end
    end

    def autopopulate_attributes
      self.class.autopopulated_attributes.each do |attr, method|
        next unless send(attr).blank?

        value = if method.respond_to?(:call)
          method.call(self)
        elsif method.is_a?(Symbol) || method.is_a?(String)
          send(method)
        else
          send("fetch_#{attr}")
        end

        send("#{attr}=", value)
      end
    end
  end
end

require 'autopopulater'

module Autopopulater
  class Railtie < ::Rails::Railtie
    initializer 'autopopulater.insert_into_active_record' do |app|
      ActiveSupport.on_load :active_record do
        Autopopulater::Railtie.insert
      end
    end
  end

  class Railtie
    def self.insert
      if defined?(ActiveRecord)
        ActiveRecord::Base.send(:include, Autopopulater::Autopopulated)
      end
    end
  end
end

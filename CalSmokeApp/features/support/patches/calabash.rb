require 'luffa'

if Calabash::Cucumber::EnvironmentHelpers.instance_methods.include?(:ios9?)
  Luffa.log_warn("Can remove iOS 9 patches")
else
  module Calabash
    module Cucumber
      module EnvironmentHelpers
        def ios9?
          device = send(:_default_device_or_create)
          device.ios_major_version == '9'
        end
      end
    end
  end
end

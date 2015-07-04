module CalSmoke
  module Dylib

    @@dylib = nil

    def self.dylib
      @@dylib ||= lambda {
        git_path = File.expand_path('~/git/calabash/calabash-ios-server/calabash-dylibs/libCalabashDynSim.dylib')
        if File.exist? git_path
          git_path
        else
          File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'libCalabashDynSim.dylib'))
        end
      }.call
    end
  end
end

#!/usr/bin/env ruby
require 'fileutils'

['5.0.2', '5.1.1'].each do |version|
  path = File.expand_path(File.join('/Xcode/', version, 'Xcode.app', 'Contents', 'Developer'))
  env =
    {
    'DEVELOPER_DIR' => path
  }
    system(env, File.expand_path('./xtc-prepare.sh'))
    FileUtils.mv(File.expand_path('./xtc-staging/CalSmoke-cal.ipa'),
                 File.expand_path("./#{version}-CalSmoke-cal.ipa"))
end

Pod::Spec.new do |s|

  s.name             = "AuthorizeMe"
  s.summary          = "Authorization with social networks"
  s.version          = "1.0.3"
  s.homepage         = "https://github.com/radislavcrechet/AuthorizeMe"
  s.license          = 'MIT'
  s.author           = { "RubyGarage" => "vlad@rubygarage.org" }
  s.source           = {
    :git => "https://github.com/radislavcrechet/AuthorizeMe.git",
    :tag => s.version.to_s
  }

  s.ios.deployment_target = '10.0'

  s.requires_arc = true
  s.source_files = 'Source/**/*.swift'

  s.preserve_paths = 'CocoaPods/**/*'
  s.pod_target_xcconfig = {
    'SWIFT_INCLUDE_PATHS[sdk=iphoneos*]'         => '$(PODS_ROOT)/AuthorizeMe/CocoaPods/iphoneos',
    'SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]'  => '$(PODS_ROOT)/AuthorizeMe/CocoaPods/iphonesimulator'
  }

end

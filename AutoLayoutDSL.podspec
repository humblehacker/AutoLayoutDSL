Pod::Spec.new do |s|
  s.name         = "AutoLayoutDSL"
  s.version      = "0.0.1"
  s.summary      = "A straightforward DSL for specifying Cocoa Auto Layout constraints."
  s.homepage     = "http://github.com/humblehacker/AutoLayoutDSL"
  s.license      = 'MIT'
  s.author       = { "David Whetstone" => "david@humblehacker.com" }
  s.source       = { :git => "git@github.com:humblehacker/AutoLayoutDSL.git", :tag => "0.0.1" }
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'
  s.public_header_files = 'Classes/**/*.h'
  s.ios.deployment_target = '5.0'
  s.requires_arc = true
  s.dependency 'BlocksKit', '~> 1.8'
  s.xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
    'CLANG_CXX_LIBRARY' => 'libc++'
  }
end

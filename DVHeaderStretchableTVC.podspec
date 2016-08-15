Pod::Spec.new do |s|
  s.name                = "DVHeaderStretchableTVC"
  s.version             = "0.0.2"
  s.summary             = "AppCore iOS."
  s.homepage            = 'https://github.com/denis-vashkovski/DVHeaderStretchableTVC'
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.authors             = { 'Denis Vashkovski' => 'denis.vashkovski.vv@gmail.com' }
  s.platform            = :ios, "7.1"
  s.source              = { :git => 'https://github.com/denis-vashkovski/DVHeaderStretchableTVC.git', :tag => s.version.to_s }
  s.ios.source_files    = 'DVHeaderStretchableTVC/DVHeaderStretchableTVC.{h,m}'
  s.requires_arc        = true
end

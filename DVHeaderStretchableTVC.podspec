Pod::Spec.new do |s|
  s.name                = "DVHeaderStretchableTVC"
  s.version             = "0.0.1"
  s.summary             = "AppCore iOS."
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.authors             = { 'Denis Vashkovski' => 'denis.vashkovski.vv@gmail.com' }
  s.platform            = :ios, "7.1"
  s.source              = { :git => 'https://github.com/ruslanskorb/RSKImageCropper.git', :tag => s.version.to_s }
  s.ios.source_files    = 'DVHeaderStretchableTVC/DVHeaderStretchableTVC.{h,m}'
  s.requires_arc        = true
end
